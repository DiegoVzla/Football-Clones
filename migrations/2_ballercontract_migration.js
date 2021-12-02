const ballerContract = artifacts.require("Ballercontract");

module.exports = function (deployer) {
  deployer.deploy(ballerContract);
};
