var VotingSystem = artifacts.require("VotingSystem");
var Votes = artifacts.require("Vote");


module.exports = function(deployer) {
  deployer.deploy(Votes);
  deployer.link(Votes, VotingSystem);
  deployer.deploy(VotingSystem);
};
