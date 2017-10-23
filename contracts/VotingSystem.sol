pragma solidity ^ 0.4.8;

// Voting system for TREBLE for estate management and issues.

contract VotingToken {
    mapping (address => uint) votingWeight;
} 

contract Vote {
    mapping (uint => bytes32) public proposals;
    mapping (uint => uint) votes;

    uint public proposalCount;
    address owner;

    uint startTime;
    uint votingTime;

    VotingToken ballot;
    function Vote(uint startingTime, uint setVotingTime) public {
        owner = msg.sender;
        startTime = startingTime;
        votingTime = setVotingTime;
    }

    function addProposal(bytes32 proposal) public returns (bool successful) {
        //require (owner == msg.sender);
        
        proposals[proposalCount] = proposal;
        proposalCount += 1;

        return true;
    }
    
    function removeProposal(uint proposalID) public returns (bool successful) {
        require (owner == msg.sender);
        require (keccak256(proposals[proposalID]) != keccak256(""));
        require (votes[proposalID] == 0);

        proposals[proposalID] = "";
        return true;
    }

    function transferOwnership(address newOwner) public {
        owner = newOwner;
    }

    function removeOwnership() public {
        require(isOver());

        owner = 0x0;
    }

    function returnVotes(uint id) constant public returns (uint) {
        return (votes[id]);        
    }
    
    function returnCurrentVote(uint id) constant public returns (bytes32, uint) {
        return (proposals[id], votes[id]);        
    }

    function getWinner() constant public returns (bytes32 winner) {
        require(isOver());

        uint id;
        uint vote;

        for (uint i = 0; i < proposalCount; i++) {
            if (keccak256(proposals[i]) != keccak256("")) 
                continue;

            if (votes[i] > vote) {
                vote = votes[i];
                id = i;
            }
        }

        return proposals[id];
    }

    function getProposalCount() constant public returns (uint) {
        return proposalCount;
    }

    function isOver() constant public returns (bool over) {
        if (startTime + votingTime > now) {
            return true;
        }
        return false;
    }

}


contract VotingSystem {
    mapping (uint => Vote) public votes;
    uint voteCount;

    function newVote(uint votingTime) public returns (uint voteID) {
        votes[voteCount] = new Vote(now, votingTime);
        voteCount += 1;

        return voteCount - 1;
    }

    function addProposal(uint voteID, bytes32 proposal) public {
        votes[voteID].addProposal(proposal);
    }

    function returnVotes(uint voteID) constant public returns (uint[]) {
        var proposalCount = votes[voteID].getProposalCount();
        var results = new uint[](proposalCount);
        for (uint i = 0; i < proposalCount; i++) {
            results[i] = votes[voteID].returnVotes(i);
        }
        return results;
    }
    

    // Requires frontend to convert from bytes32 to string
    function returnCurrentVote(uint voteID) constant public returns (bytes32[], uint[]) {
        var proposalCount = votes[voteID].getProposalCount();
        var proposalResults = new bytes32[](proposalCount);
        var voteResults = new uint[](proposalCount);
        
        for (uint i = 0; i < proposalCount; i++) {
            (proposalResults[i],voteResults[i]) = votes[voteID].returnCurrentVote(i);
        }

        return (proposalResults, voteResults);
    }

}