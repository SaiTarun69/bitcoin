defmodule Bitcoin do
  def users(num) do
    userLen=Enum.map(1..num,&(&1))
    li=Enum.map(userLen, fn(x) ->
      {:ok, pid}= Genclass.start_link
      private_key = :crypto.strong_rand_bytes(32) |> Base.encode16
      public_key = :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), private_key)
                    |> elem(0) |> Base.encode16
      Genclass.processKeys(pid, x, private_key, public_key)
      pid
      end)
    transactionList = Enum.map(li, fn(x) ->
                        tli = [0, Genclass.getPublicKey(x), 100]
                        tli
                      end)
    IO.inspect li
    genNonce = Transaction.findNonce(transactionList, "0", 0)
    chain = Blockchain.new([], transactionList, genNonce)
    IO.inspect chain

    Enum.each(li, fn(x) ->
                Genclass.broadCastTransactions(x, transactionList)
              end)
    blockVar = hd(chain)
    IO.inspect blockVar.timestamp
    # Enum.each(li, fn(x) ->
    #   temp = Genclass.getTranLi(x)
    #   IO.inspect temp
    # end)
    # Enum.each(transactionList, fn(x) ->
    #       #bal=Genclass.getAmount(x)
    #       IO.inspect x
    #     end)
    # fullNet(li)

    #Transaction.transaction(li, 0)

    # Enum.each(li, fn(x) ->
    #     bal=Genclass.getAmount(x)
    #     IO.inspect bal
    #   end)

    
    # Enum.map(0..num-1, fn(x) ->
    #   id=Enum.at(li, x)
    #   #IO.inspect id
    #   netli=Genclass.nodeNetList(id)
    #   #IO.inspect netli
    #   str="message"<>Integer.to_string(x)
    #   Genclass.broadCast(id, str)
    #   :timer.sleep(1)
    # end)

    # #:timer.sleep(10)
    # Enum.each(li, fn(x) ->
    #   msg=Genclass.curMsg(x)
    #   IO.inspect msg
    # end)

    #loopfun(1)
  end

  def loopfun(1) do
    loopfun(1)
  end

  def main(args\\[]) do
    {i,""}=Integer.parse(Enum.at(args,0))
    #{j,""}=Integer.parse(Enum.at(args,1))
    #j=Enum.at(args,1)
    #k=Enum.at(args,2)
    #pid=spawn(Dosproj, :pmap, [i, j])
    users(i)
  end
  
  def fullNet(li) do
    Enum.each(li, fn(x) ->
        adjLi=li--[x]
        #IO.inspect adjLi
        Genclass.fullNetLi(x, adjLi)
    end)
  end

end
