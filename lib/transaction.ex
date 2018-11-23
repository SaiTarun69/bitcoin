defmodule Transaction do
    def transaction(li, count) do
        if(count<3) do
            blockli = recFun(li, 10, [])
            #IO.puts length(blockli)
            #IO.inspect blockli
            IO.puts "---------------------------------------------------------"
            findNonce(blockli, 0 , 0)
            :timer.sleep(5)
            transaction(li, count+1)
        end
    end

    def transaction(li, 0) do
        
    end

    def recFun(li, 0, blockli) do
        blockli
    end

    def recFun(li, n, blockli) do
        #IO.puts n
        blockli = if n > 0 do
            sender=Enum.random(li)
            receiver = Enum.random(li--[sender])
            amount = Enum.random(1..50)
            senderBal = Genclass.getAmount(sender)
            receiverBal = Genclass.getAmount(receiver)
            if(senderBal >= amount) do
                Genclass.setAmount(sender, senderBal-amount)
                Genclass.setAmount(receiver, receiverBal+amount)
                tranli = [Genclass.getProcId(sender), Genclass.getProcId(receiver), amount]
                #IO.inspect tranli
                #IO.inspect blockli
                recFun(li, n-1, blockli++[tranli])
            else
                #IO.puts "comes to else"
                recFun(li, n, blockli)
            end
        end
        blockli
    end

    def findNonce(blockli, prevHash, index) do
        #IO.puts "in find Nonce"
        datahash= :crypto.hash(:sha256, blockli++[prevHash]++[index]) |> Base.encode16
        IO.inspect datahash
        finalNonce = getTarget(datahash, Enum.random(1..4294967296))
        IO.inspect finalNonce
    end

    def getTarget(datahash, nonceValue) do
        #IO.puts nonceValue
        str = datahash<>to_string(nonceValue)
        curHash= :crypto.hash(:sha256, str) |> Base.encode16
        finalNonce = if String.slice(curHash, 0..3)=="0000" do
                        nonceValue
                    else
                        getTarget(datahash, Enum.random(1..2147483647))
                    end
        finalNonce
    end
end