defmodule Database.PhData do
  @moduledoc """
    This module is responsible for doing the CRUD operations of pH data.
  """
  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias FermentationSystem.Repo
  alias Database.PhData.Schema, as: PhData

  @spec get_ph_data :: list(PhData.t())
  def get_ph_data, do: Repo.all(PhData)

  @spec insert_ph_datum(changes :: map()) :: {:ok, map()} | {:error, map()}
  def insert_ph_datum(changes) do
    %PhData{}
    |> PhData.changeset(changes)
    |> Repo.insert()
  end

  @spec update_ph_datum(id :: term(), changes :: map()) :: {:ok, PhData.t()} | {:error, map()}
  def update_ph_datum(id, changes) do
    PhData
    |> Repo.get(id)
    |> persist_update(changes)
  end

  @spec get_ph_data_in_rank_time(initial_date :: term(), final_date :: term()) :: {:ok, list({:ok, PhData.t()})}
  def get_ph_data_in_rank_time(initial_date, final_date) do
    ph_data = from(ph_Data in PhData,
      where: fragment("?::date", ph_Data.inserted_at) >= ^initial_date and fragment("?::date", ph_Data.inserted_at) <= ^final_date
    )
    |> Repo.all()

    {:ok, ph_data}
  end

  def get_ph_datum_by_id(id) do
    ph_datum = Repo.get_by(PhData, id: id)
    {:ok, ph_datum}
  end

  def delete_ph_datum(id) do
    id
    |> get_ph_datum_by_id()
    |> delete()
  end

  @spec delete({:ok, PhData.t() | nil}) :: {:ok, PhData.t()} | {:error, term()}
  defp delete({:ok, nil}), do: {:error, :ph_datum_not_found}
  defp delete({:ok, ph_datum}), do: Repo.delete(ph_datum)

  @spec persist_update(ph_data :: PhData.t(), changes :: map()) :: {:ok, PhData.t()} | {:error, term()}
  defp persist_update(nil, _changes), do: {:error, :not_found}

  defp persist_update(ph_data, changes) do
    ph_data
    |> PhData.changeset(changes)
    |> Repo.update()
  end
end
