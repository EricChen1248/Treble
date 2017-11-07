pragma solidity ^ 0.4.8;

// Voting system for TREBLE for estate management and issues.

import "./Vote.sol";
contract VotingSystem {
    mapping (uint => Vote) public votes;
    uint voteCount;

    function newVote(uint votingTime, address[] voters, uint[] tokens) public returns (uint voteID) {
        votes[voteCount] = new Vote(now, votingTime, voters, tokens);
        voteCount += 1;

        return voteCount - 1;
    }

    function voteFor(uint voteID, uint proposalID, uint vote) public {
        votes[voteID].voteFor(msg.sender, proposalID, vote);
    }

    function transferVote(uint voteID, address receiver, uint vote) public {
        votes[voteID].transferVote(msg.sender, receiver, vote);
    }

    function addProposal(uint voteID, bytes32 proposal) public {
        votes[voteID].addProposal(proposal);
    }

    function removeProposal(uint voteID, uint proposalID) public {
        votes[voteID].removeProposal(proposalID);
    }

    function transferOwnership(uint voteID, address newOwner) public {
        votes[voteID].transferOwnership(newOwner);
    }

    function returnVotes(uint voteID) constant public returns (uint[]) {
        var proposalCount = votes[voteID].getProposalCount();
        var results = new uint[](proposalCount);
        for (uint i = 0; i < proposalCount; i++) {
            results[i] = votes[voteID].returnVotes(i);
        }
        return results;
    }

    function returnCurrentVote(uint voteID, uint proposalID) constant public returns (bytes32, uint) {
        return (votes[voteID].returnProposal(proposalID), votes[voteID].returnVotes(proposalID));
    }

    function getWinner(uint voteID) constant public returns (bytes32 winner) {
        return votes[voteID].getWinner();
    }

    function getProposalCount(uint voteID) constant public returns (uint count) {
        return votes[voteID].getProposalCount();
    }


}