defmodule Database.SensorsData do
  @moduledoc """
    This module is responsible for doing the CRUD operations of sensors data.
  """
  import Ecto.Query, warn: false

  alias FermentationSystem.Repo
  alias Database.{SensorData, Sensor}

  @spec get_specific_type_data(type :: atom()) :: {:ok, list(SensorData.t())}
  def get_specific_type_data(type) do
    data = from(data in SensorData,
    join: sensor in Sensor,
    on: data.sensor_mac == sensor.mac,
    where: sensor.type == ^type)
    |> Repo.all()

    {:ok, data}
  end

  @spec insert_datum(changes :: map()) :: {:ok, map()} | {:error, map()}
  def insert_datum(changes) do
    %SensorData{}
    |> SensorData.changeset(changes)
    |> Repo.insert()
  end

  @spec update_datum(id :: term(), changes :: map()) :: {:ok, SensorData.t()} | {:error, map()}
  def update_datum(id, changes) do
    SensorData
    |> Repo.get(id)
    |> persist_update(changes)
  end

  @spec get_specific_data_in_rank_time(type :: atom(), fermentation_process_id :: binary(), initial_date :: term(), final_date :: term()) :: {:ok, list({:ok, SensorData.t()})}
  def get_specific_data_in_rank_time(type, fermentation_process_id, initial_date, final_date) do
    data = from(data in SensorData,
    join: sensor in Sensor,
    on: data.sensor_mac == sensor.mac,
    where: sensor.fermentation_process_id == ^fermentation_process_id and
           sensor.type == ^type and
           fragment("?::date", data.inserted_at) >= ^initial_date and
           fragment("?::date", data.inserted_at) <= ^final_date
    )
    |> Repo.all()

    {:ok, data}
  end

  @spec get_datum_by_id(id :: binary()) :: {:ok, SensorData.t()}
  def get_datum_by_id(id) do
    datum = Repo.get_by(SensorData, id: id)

    {:ok, datum}
  end

  @spec delete_datum(id :: binary()) :: {:ok, SensorData.t()} | {:error, term()}
  def delete_datum(id) do
    id
    |> get_datum_by_id()
    |> delete()
  end

  @spec delete({:ok, datum :: SensorData.t() | nil}) :: {:ok, SensorData.t()} | {:error, term()}
  defp delete({:ok, nil}), do: {:error, :datum_not_found}
  defp delete({:ok, datum}), do: Repo.delete(datum)

  @spec persist_update(datum :: SensorData.t(), changes :: map()) :: {:ok, SensorData.t()} | {:error, term()}
  defp persist_update(nil, _changes), do: {:error, :not_found}

  defp persist_update(datum, changes) do
    datum
    |> SensorData.changeset(changes)
    |> Repo.update()
  end
end
