const ColorsERC721 = artifacts.require("./ColorsERC721.sol");

module.exports = function(deployer) {
  deployer.deploy(ColorsERC721);
};
