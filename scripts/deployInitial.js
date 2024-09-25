const hre = require("hardhat");

async function main() {
  const TitulacionLogic = await hre.ethers.getContractFactory("TitulacionDigitalLogic");
  const titulacionLogic = await TitulacionLogic.deploy();
  console.log("TitulacionDigitalLogic deployed to:", titulacionLogic.target);

  const TitulacionDigitalProxy = await hre.ethers.getContractFactory("TitulacionDigitalProxy");
  const titulacionProxy = await TitulacionDigitalProxy.deploy(titulacionLogic.target);
  console.log("TitulacionDigitalProxy deployed to:", titulacionProxy.target);
}

main()
  .then(() => process.exit(0)) 
  .catch((error) => {
    console.error("Deployment failed:", error); 
    process.exit(1); 
  });