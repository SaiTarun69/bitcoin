defmodule BitcoinTest do
  use ExUnit.Case
  doctest Bitcoin

  # test "greets the world" do
  #   assert Bitcoin.hello() == :world
  # end

  test "creating users" do
    assert Bitcoin.userlist([1,2,4,7])
  end

  test "creating minors" do
    assert Bitcoin.minorList([3,5,6])
  end

  test "user wallet generation" do
    assert Bitcoin.wallet
  end

  test "genicess block's transaction data" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    assert Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
  end

  test "Block data hashing" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    assert Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
  end

  test "Generating Nonce as per the transaction data" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    assert Transaction.findNonce(datahash)
  end

  test "Block Hash generation" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    genNonce = Transaction.findNonce(datahash)
    assert Transaction.findCurHash(datahash, genNonce)
  end

  test "Finding Nonce for random string" do
    assert Transaction.findNonce("datahash")
  end

  test "Creating dummy block" do
    assert Blockchain.new([], ["tarnsactionList","khdkhgsdh"], 4987600, "khheghjgsljgshg")
  end

  test "Block creation" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    genNonce = Transaction.findNonce(datahash)
    curHash = Transaction.findCurHash(datahash, genNonce)
    assert Blockchain.new([], tarnsactionList, genNonce, curHash)
  end

  test "Broadcasting Block to all the users" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    genNonce = Transaction.findNonce(datahash)
    curHash = Transaction.findCurHash(datahash, genNonce)
    chain = Blockchain.new([], tarnsactionList, genNonce, curHash)
    assert Genclass.broadCastBlock(:user, chain, [])
  end

  test "Complete functionality with user transactions and block chain creation" do
    userli=Bitcoin.userlist([1,2,4,7])
    minorli=Bitcoin.minorList([3,5,6])
    totalUsers = userli ++ minorli
    [mainSK, mainPK] = Bitcoin.wallet
    tarnsactionList = Bitcoin.genblockTransLi(totalUsers, mainSK, mainPK)
    datahash = Bitcoin.dataHasing(tarnsactionList, ["0"], [0])
    genNonce = Transaction.findNonce(datahash)
    curHash = Transaction.findCurHash(datahash, genNonce)
    chain = Blockchain.new([], tarnsactionList, genNonce, curHash)
    #Genclass.broadCastBlock(:user, chain, [])
    assert Transaction.transaction(totalUsers, 0, chain)
  end  
end
