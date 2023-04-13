const main = async () => {
  //const [owner, randomPerson] = await hre.ethers.getSigners();
  //const signers = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("Contract Address:", waveContract.address);
  //console.log("Contract deployed by:", owner.address);
  //console.log("Contract deployed by:", signers[0].address);

  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Balance of the contract:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  const waveTxn = await waveContract.getNewUsers("Hi there #1");
  await waveTxn.wait()
  
  const waveTxn2 = await waveContract.getNewUsers("Hi there #2");
  await waveTxn2.wait()

  // for (const signer of signers){
  //     console.log("Joining from address:", signer.address);
  //     let waveTxn = await waveContract.connect(signer).getNewUsers("Some Message");
  //     await waveTxn.wait();
      
  //     const [_, randomPerson] = await hre.ethers.getSigners();
  //     waveTxn = await waveContract.connect(randomPerson).getNewUsers("Other message!");
  //     await waveTxn.wait(); // aguarda a transação ser minerada
      
  //     let allJoins = await waveContract.getAllJoiners();
  //     console.log(allJoins);
  // }

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Balance of the contract:",
              hre.ethers.utils.formatEther(contractBalance)
  );

  let pokeFanaticCount = await waveContract.getTotalNewUsers();
  console.log(pokeFanaticCount)
};
      
const runMain = async () => {
try {
  await main();
  process.exit(0);
} catch (error) {
  console.log(error);
  process.exit(1);
}
};

runMain();
