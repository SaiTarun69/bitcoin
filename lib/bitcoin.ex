defmodule Bitcoin do
  def users(num) do
    userLen=Enum.map(1..num,&(&1))
    minorLen = Enum.take_random(userLen, 5)
    userLen = userLen -- minorLen
    userli=Enum.map(userLen, fn(x) ->
      {:ok, pid}= Genclass.start_link(:user)
      private_key = :crypto.strong_rand_bytes(32) |> Base.encode16
      public_key = :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), private_key)
                    |> elem(0) |> Base.encode16
      Genclass.processKeys(pid, x, private_key, public_key)
      pid
      end)

    minorli=Enum.map(minorLen, fn(x) ->
      {:ok, pid}= Genclass.start_link2({:user, :minor})
      private_key = :crypto.strong_rand_bytes(32) |> Base.encode16
      public_key = :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), private_key)
                    |> elem(0) |> Base.encode16
      Genclass.processKeys(pid, x, private_key, public_key)
      pid
      end)

    totalUsers = userli ++ minorli
    transactionList = Enum.map(totalUsers, fn(x) ->
                        tli = [0, Genclass.getPublicKey(x), 100]
                        Genclass.broadCastTransactions(:user, tli)
                        tli
                      end)
    IO.inspect totalUsers
    datahash= :crypto.hash(:sha256, transactionList++["0"]++[0]) |> Base.encode16
    #IO.inspect datahash
    genNonce = Transaction.findNonce(datahash)
    curHash = Transaction.findCurHash(datahash, genNonce)
    chain = Blockchain.new([], transactionList, genNonce, curHash)
    #IO.inspect chain

    Genclass.broadCastBlock(:user, chain)
    # Enum.each(totalUsers, fn(x) ->
    #   temp = Genclass.getBlockLi(x)
    #   IO.inspect temp
    # end)

    # Enum.each(totalUsers, fn(x) ->
    #             Genclass.broadCastTransactions(x, transactionList)
    #           end)
    #Genclass.broadCastTransactions(:user, transactionList)
    blockVar = hd(chain)
    #IO.inspect blockVar.timestamp
    # Enum.each(transactionList, fn(x) ->
    #       #bal=Genclass.getAmount(x)
    #       IO.inspect x
    #     end)
    # fullNet(li)

    Transaction.transaction(totalUsers, 0, chain)

    # Enum.each(li, fn(x) ->
    #     bal=Genclass.getAmount(x)
    #     IO.inspect bal
    #   end)

    Enum.each(totalUsers, fn(x) ->
      temp = Genclass.getTranLi(x)
      IO.inspect temp
    end)
    
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
