const hre = require("hardhat");

async function main() {
  const proxyAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

  const TitulacionLogic = await hre.ethers.getContractFactory("TitulacionDigitalLogic");
  const newLogic = await TitulacionLogic.deploy();
  console.log("New TitulacionDigitalLogic deployed to:", newLogic.target);

  const TitulacionDigitalProxy = await hre.ethers.getContractAt("TitulacionDigitalProxy", proxyAddress);

  const upgradeTx = await TitulacionDigitalProxy.upgrade(newLogic.target);
  await upgradeTx.wait();
  console.log(`Proxy upgraded to new implementation at: ${newLogic.target}`);
}

main()
  .then(() => process.exit(0)) 
  .catch((error) => {
    console.error("Deployment failed:", error); 
    process.exit(1); 
  });