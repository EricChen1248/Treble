var VotingSystem = artifacts.require("VotingSystem");
var Votes = artifacts.require("VotingSystem");
var VotingToken = artifacts.require("VotingToken")


module.exports = function(deployer) {
  deployer.deploy(VotingToken);
  deployer.link(VotingToken, Votes);
  deployer.deploy(Votes);
  deployer.link(Votes, VotingSystem);
  deployer.deploy(VotingSystem);
};
