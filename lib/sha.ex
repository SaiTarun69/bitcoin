defmodule Sha do
    @hash_fields [:index, :data, :nonce, :timestamp, :prev_hash]
  
    def hash(%{} = block) do
      block |> Map.take(@hash_fields)
            |> Poison.encode!
            |> sha256
    end
  
    def insert_hash(%{} = block) do
      %{block | hash: hash(block)}
    end
  
    def sha256(binary) do
      :crypto.hash(:sha256, binary) |> Base.encode16
    end
  
  end