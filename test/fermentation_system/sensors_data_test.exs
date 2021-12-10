defmodule FermentationSystem.SensorsDataTests do
  use ExUnit.Case
  alias Database.SensorsData
  import Database.Factory

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(FermentationSystem.Repo)
  end

  describe "get_specific_type_data/1" do
    test "Gets pH data" do
      [sensor1, sensor2] = insert_list(2, :sensor)
      sensor3 = insert(:sensor, type: :temperature)

      insert(:sensor_data, sensor_mac: sensor1.mac)
      insert_list(2, :sensor_data, sensor_mac: sensor2.mac)
      insert(:sensor_data, sensor_mac: sensor3.mac)

      {status, sensors_data} = SensorsData.get_specific_type_data(:ph)

      assert status == :ok
      assert length(sensors_data) == 3
    end

    test "Gets temperature data" do
      [sensor1, sensor2] = insert_list(2, :sensor, type: :temperature)
      sensor3 = insert(:sensor)

      insert(:sensor_data, sensor_mac: sensor1.mac)
      insert(:sensor_data, sensor_mac: sensor2.mac)
      insert(:sensor_data, sensor_mac: sensor3.mac)

      {status, sensors_data} = SensorsData.get_specific_type_data(:temperature)

      assert status == :ok
      assert length(sensors_data) == 2
    end

    test "Returns an empty list when there aren't data of the specific type" do
      sensor = insert(:sensor)
      insert_list(3, :sensor_data, sensor_mac: sensor.mac)

      {status, sensors_data} = SensorsData.get_specific_type_data(:temperature)

      assert status == :ok
      assert length(sensors_data) == 0
    end
  end

  describe "insert_datum/1" do
    setup do
      sensor = insert(:sensor)

      {:ok, sensor: sensor}
    end

    test "Inserts new sensor datum correctly", %{sensor: sensor} do
      {status, datum} = SensorsData.insert_datum(%{value: 4.5, sensor_mac: sensor.mac})

      assert status == :ok
      assert SensorsData.get_datum_by_id(datum.id) == {:ok, datum}
    end

    test "Returns an error when sensor mac doesn't exist" do
      {status, response} = SensorsData.insert_datum(%{value: 4.5, sensor_mac: "ABCDE"})

      assert status == :error
      assert response.errors ==  [sensor_mac: {"does not exist", [constraint: :foreign,
               constraint_name: "sensors_data_sensor_mac_fkey"]}]
    end

    test "Returns an error when a required field is not included", %{sensor: sensor} do
      {status, response} = SensorsData.insert_datum(%{sensor_mac: sensor.mac})

      assert status == :error
      assert response.errors ==   [value: {"can't be blank", [validation: :required]}]
    end
  end

  describe "update_datum/2" do
    test "Updates correctly a sensor datum" do
      %{sensor_mac: old_sensor_mac} = datum = insert(:sensor_data)
      sensor = insert(:sensor)

      {status, updated_datum} = SensorsData.update_datum(datum.id, %{sensor_mac: sensor.mac})

      assert status == :ok
      assert updated_datum.sensor_mac == sensor.mac
      refute updated_datum.sensor_mac == old_sensor_mac
    end

    test "Returns an error when the updated sensor mac doesn't exist" do
      datum = insert(:sensor_data)

      {status, response} = SensorsData.update_datum(datum.id, %{sensor_mac: "ABHJ"})

      assert status == :error
      assert response.errors == [sensor_mac: {"does not exist", [constraint: :foreign,
               constraint_name: "sensors_data_sensor_mac_fkey"]}]
    end

    test "Returns an error when the datum to be updated doesn't exist" do
      {status, response} = SensorsData.update_datum("f897a57d-b868-466e-925d-b53f30dbdbfc", %{value: 12})

      assert status == :error
      assert response == :not_found
    end
  end

  describe "get_specific_data_in_rank_time/4" do
    setup do
      fermentation_process = insert(:fermentation_process)
      ph_sensor = insert(:sensor, fermentation_process: fermentation_process)
      temperature_sensor = insert(:sensor, fermentation_process: fermentation_process, type: :temperature)

      {:ok, fermentation_process: fermentation_process, ph_sensor: ph_sensor, temperature_sensor: temperature_sensor}
    end

    test "Gets ph data in rank time", %{fermentation_process: fermentation_process, ph_sensor: ph_sensor,
      temperature_sensor: temperature_sensor} do
      datum1= insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-12-10 03:01:08])
      datum2= insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-11-30 03:01:08])
      datum3= insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])
      datum4= insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])

      {status, data} = SensorsData.get_specific_data_in_rank_time(:ph, fermentation_process.id, ~D[2021-11-30], ~D[2021-12-10])

      assert status == :ok
      assert Enum.any?(data, fn %{id: id} -> datum1.id == id end)
      assert Enum.any?(data, fn %{id: id} -> datum2.id == id end)
      refute Enum.any?(data, fn %{id: id} -> datum3.id == id end)
      refute Enum.any?(data, fn %{id: id} -> datum4.id == id end)
      assert length(data) == 2
    end

    test "Gets temperature data in rank time", %{fermentation_process: fermentation_process, ph_sensor: ph_sensor,
      temperature_sensor: temperature_sensor} do
      datum1= insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-12-10 03:01:08])
      datum2= insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-30 03:01:08])
      datum3= insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])
      datum4= insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])

      {status, data} = SensorsData.get_specific_data_in_rank_time(:temperature, fermentation_process.id, ~D[2021-11-10], ~D[2021-11-20])

      assert status == :ok
      assert Enum.any?(data, fn %{id: id} -> datum3.id == id end)
      assert Enum.any?(data, fn %{id: id} -> datum4.id == id end)
      refute Enum.any?(data, fn %{id: id} -> datum1.id == id end)
      refute Enum.any?(data, fn %{id: id} -> datum2.id == id end)
      assert length(data) == 2
    end

    test "Returns an empty list when there isn't data in the specified rank time",
         %{fermentation_process: fermentation_process, ph_sensor: ph_sensor, temperature_sensor: temperature_sensor} do
      insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-12-10 03:01:08])
      insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-11-30 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])

      {status, data} = SensorsData.get_specific_data_in_rank_time(:temperature, fermentation_process.id, ~D[2021-12-11], ~D[2021-12-20])

      assert status == :ok
      assert length(data) == 0
    end
  end

  describe "get_datum_by_id/1" do
    test "Gets a datum by id" do
      datum = insert(:sensor_data)

      {status, response} = SensorsData.get_datum_by_id(datum.id)

      assert status == :ok
      assert response == datum
    end

    test "Returns an error when the id doesn't correspond to any datum" do
      {status, response} = SensorsData.get_datum_by_id("f897a57d-b868-466e-925d-b53f30dbdbfc")

      assert status == :ok
      assert response == nil
    end
  end

  describe "delete_datum/1" do
    test "Deletes a datum correctly" do
      datum = insert(:sensor_data)

      {status, response} = SensorsData.delete_datum(datum.id)

      assert status == :ok
      assert response.id == datum.id
      assert SensorsData.get_datum_by_id(datum.id) == {:ok, nil}
    end

    test "Returns an error when the id doesn't correspond to any datum" do
      {status, response} = SensorsData.delete_datum("f897a57d-b868-466e-925d-b53f30dbdbfc")

      assert status == :error
      assert response == :datum_not_found
    end
  end
end