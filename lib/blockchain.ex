defmodule Blockchain do

    def new(chain, data, nonce) do
        block = data |> Block.zero(nonce)
      [Sha.insert_hash(block)]
    end
  
    def insert_block(chain, data, nonce) do
      %Block{index: ind, hash: prev} = hd(chain)
      block = data |> Block.new(ind+1, nonce, prev) |> Sha.insert_hash
      [block | chain]
  
    end
  end