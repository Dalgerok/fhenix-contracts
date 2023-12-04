import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:asEuint16").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResult = await deploy("AsEuint16", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResult.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("AsEuint16", deployResult.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResult.address);

  const tests = ["asEuint16Uint256", "asEuint16Euint8", "asEuint16Euint32"];
  for (const test of tests) {
    try {
      let plaintextInput = Math.floor(Math.random() * 1000) % 256;

      //@ts-expect-error
      let encryptedOutput = await contract.connect(signer)[test](plaintextInput, publicKey);
      let decryptedOutput = instance.decrypt(deployResult.address, encryptedOutput);

      if (decryptedOutput === plaintextInput) {
        console.log(`${test}: OK`);
      } else {
        console.log(`${test}: FAIL - ${decryptedOutput} != ${plaintextInput}`);
      }
    } catch (error) {
      console.log(`${test}: FAIL - ${error}`);
    }
  }

  try {
    let plaintextInput = Math.floor(Math.random() * 1000) % 256;

    const ciphertextInput = instance.encrypt32(plaintextInput);

    let encryptedOutput = await contract.connect(signer).asEuint16Bytes(ciphertextInput, publicKey);
    let decryptedOutput = instance.decrypt(deployResult.address, encryptedOutput);

    if (decryptedOutput === plaintextInput) {
      console.log(`asEuint16Bytes: OK`);
    } else {
      console.log(`asEuint16Bytes: FAIL - ${decryptedOutput} != ${plaintextInput}`);
    }
  } catch (error) {
    console.log(`asEuint16Bytes: FAIL - ${error}`);
  }
});
