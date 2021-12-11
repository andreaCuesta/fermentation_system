defmodule FermentationSystemWeb.SensorsDataControllerTest do
  @moduledoc false

  use FermentationSystemWeb.ConnCase

  import Database.Factory

  alias FermentationSystemWeb.Router.Helpers, as: Routes

  describe "index" do
    setup do
      fermentation_process = insert(:fermentation_process)
      ph_sensor = insert(:sensor, fermentation_process: fermentation_process)
      temperature_sensor = insert(:sensor, fermentation_process: fermentation_process, type: :temperature)

      {:ok, fermentation_process: fermentation_process, ph_sensor: ph_sensor, temperature_sensor: temperature_sensor}
    end

    test "returns all fermentation process' ph data in a rank time", %{conn: conn, fermentation_process: fermentation_process, ph_sensor: ph_sensor,
      temperature_sensor: temperature_sensor} do
      datum1 = insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-12-10 03:01:08])
      datum2 = insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-11-30 03:01:08])
      insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-11-20 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])

      conn = get(conn, Routes.sensors_data_path(conn, :index, :ph, fermentation_process.id), %{"initial_date" => "2021-11-29", "final_date" => "2021-12-11"})

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => datum1.id,
                 "mac_sensor" => datum1.sensor_mac,
                 "value" => datum1.value,
                 "inserted_at" => "2021-12-10T03:01:08",
               },
               %{
                 "id" => datum2.id,
                 "mac_sensor" => datum2.sensor_mac,
                 "value" => datum2.value,
                 "inserted_at" => "2021-11-30T03:01:08"
               }
             ]

      assert json_response(conn, 200)["status"] == "success"
    end

    test "returns all fermentation process' temperature data in a rank time", %{conn: conn, fermentation_process: fermentation_process, ph_sensor: ph_sensor,
      temperature_sensor: temperature_sensor} do
      insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-12-10 03:01:08])
      insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-11-30 03:01:08])
      datum1 = insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])
      datum2 = insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-20 03:01:08])


      conn = get(conn, Routes.sensors_data_path(conn, :index, :temperature, fermentation_process.id), %{"initial_date" => "2021-11-09", "final_date" => "2021-11-11"})

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => datum1.id,
                 "mac_sensor" => datum1.sensor_mac,
                 "value" => datum1.value,
                 "inserted_at" => "2021-11-10T03:01:08",
               },
               %{
                 "id" => datum2.id,
                 "mac_sensor" => datum2.sensor_mac,
                 "value" => datum2.value,
                 "inserted_at" => "2021-11-10T03:01:08"
               }
             ]

      assert json_response(conn, 200)["status"] == "success"
    end

    test "returns an empty list when there aren't ph values in the rank time", %{conn: conn, fermentation_process: fermentation_process,
      ph_sensor: ph_sensor, temperature_sensor: temperature_sensor} do
      insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-12-10 03:01:08])
      insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-11-30 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-20 03:01:08])


      conn = get(conn, Routes.sensors_data_path(conn, :index, :ph, fermentation_process.id), %{"initial_date" => "2021-11-09", "final_date" => "2021-11-11"})

      assert json_response(conn, 200)["data"] == []
      assert json_response(conn, 200)["status"] == "success"
    end

    test "returns an empty list when there aren't temperature values in the rank time", %{conn: conn, fermentation_process: fermentation_process,
      ph_sensor: ph_sensor, temperature_sensor: temperature_sensor} do
      insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-12-10 03:01:08])
      insert(:sensor_data, sensor_mac: ph_sensor.mac, inserted_at: ~N[2021-11-30 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-10 03:01:08])
      insert(:sensor_data, sensor_mac: temperature_sensor.mac, inserted_at: ~N[2021-11-20 03:01:08])


      conn = get(conn, Routes.sensors_data_path(conn, :index, :temperature, fermentation_process.id), %{"initial_date" => "2021-12-09", "final_date" => "2021-12-11"})

      assert json_response(conn, 200)["data"] == []
      assert json_response(conn, 200)["status"] == "success"
    end
  end

  describe "set" do
    test "sets correctly a new sensor ph data", %{conn: conn} do
      sensor = insert(:sensor)

      conn = post(conn, Routes.sensors_data_path(conn, :set), %{"value" => "1.6", "sensor_mac" => sensor.mac})

      refute is_nil(json_response(conn, 200)["new_datum_id"])
      assert json_response(conn, 200)["status"] == "success"
    end

    test "sets correctly a new sensor temperature data", %{conn: conn} do
      sensor = insert(:sensor, type: :temperature)

      conn = post(conn, Routes.sensors_data_path(conn, :set), %{"value" => "20", "sensor_mac" => sensor.mac})

      refute is_nil(json_response(conn, 200)["new_datum_id"])
      assert json_response(conn, 200)["status"] == "success"
    end

    test "returns an error when the sensor to be set new data doesn't exist", %{conn: conn} do
      conn = post(conn, Routes.sensors_data_path(conn, :set), %{"value" => "1.6", "sensor_mac" => "ABDG"})

      assert json_response(conn, 422)["errors"] ==  "sensor_mac does not exist, "
      assert json_response(conn, 422)["status"] == "failed"
    end

    test "returns an error when the value to be set is invalid", %{conn: conn} do
      sensor = insert(:sensor)
      conn = post(conn, Routes.sensors_data_path(conn, :set), %{"value" => "hjhkj", "sensor_mac" => sensor.mac})

      assert json_response(conn, 422)["errors"] ==  "value is invalid, "
      assert json_response(conn, 422)["status"] == "failed"
    end
  end
end