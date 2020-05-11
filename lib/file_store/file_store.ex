defmodule Api.FileStore do
  @doc """
    Returns {:ok, file_id} on success, {:error, reason} on failure
  """
  def put_file(datadir, file_path) do
    case File.read(file_path) do
      {:ok, binary} -> put_binary(datadir, binary)
      {:error, reason} -> {:error, reason}
    end
  end

  def get_file(datadir, file_id) do
    path = Path.join(datadir, make_file_path(file_id))

    case File.open(path, [:binary, :read]) do
      {:ok, file} -> IO.binread(file, :all)
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
    Returns local path for file with id @file_id
  """
  def get_file_path(datadir, file_id) do
    path = Path.join(datadir, make_file_path(file_id))
    if File.exists?(path), do: path, else: nil
  end

  @doc """
    Returns :ok if successful, or {:error, reason} if an error occurs.
  """
  def delete_file(datadir, file_id) do
    path = Path.join(datadir, make_file_path(file_id))
    File.rm(path)
  end

  defp put_binary(datadir, binary) do
    file_id =
      :crypto.hash(:sha256, binary)
      |> Base.encode32(padding: false, case: :lower)

    path = Path.join(datadir, make_file_path(file_id))

    case File.mkdir_p(Path.dirname(path)) do
      {:error, reason} ->
        {:error, reason}

      _ ->
        case File.open(path, [:binary, :write]) do
          {:ok, out_file} ->
            IO.binwrite(out_file, binary)
            File.close(out_file)
            {:ok, file_id}

          {:error, reason} ->
            {:error, reason}
        end
    end
  end

  defp make_file_path(hash52) when byte_size(hash52) == 52 do
    0..12
    |> Enum.to_list()
    |> Enum.map(fn x -> (x * 4)..(x * 4 + 3) end)
    |> Enum.map(fn range -> String.slice(hash52, range) end)
    |> Path.join()
  end
end
