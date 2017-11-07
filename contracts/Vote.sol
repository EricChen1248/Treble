pragma solidity ^ 0.4.8;

contract Vote {
    mapping (uint => bytes32) public proposals;
    mapping (uint => uint) votes;
    mapping (address => uint) public usableVotes;
    

    uint public proposalCount;
    address owner;

    uint startTime;
    uint votingTime;

    function Vote(uint startingTime, uint setVotingTime, address[] voters, uint[] tokens) public {
        owner = msg.sender;
        startTime = startingTime;
        votingTime = setVotingTime;

        for (uint i = 0; i < voters.length; i++) {
            usableVotes[voters[i]] = tokens[i];
        }
    }


    function voteFor(address voter,uint proposalID, uint vote) public returns(bool successful) {
        if (usableVotes[voter] < vote) {
            return false;
        }
        require(usableVotes[voter] > vote);
        require(!isOver());
        usableVotes[voter] -= vote;
        votes[proposalID] += vote;

        return true;
    }

    function transferVote(address sender, address receiver, uint vote) public returns (bool successful) {
        require(!isOver());
        require(usableVotes[sender] > vote);

        usableVotes[sender] -= vote;
        usableVotes[receiver] += vote;
        return true;
    }

    function addProposal(bytes32 proposal) public returns (bool successful) {
        proposals[proposalCount] = proposal;
        proposalCount += 1;

        return true;
    }
    
    function removeProposal(uint proposalID) public returns (bool successful) {
        require (keccak256(proposals[proposalID]) != keccak256(""));
        require (votes[proposalID] == 0);

        proposals[proposalID] = "";
        return true;
    }

    function transferOwnership(address newOwner) public {
        owner = newOwner;
    }

    function removeOwnership() private {
        owner = 0x0;
    }

    function returnVotes(uint id) constant public returns (uint) {
        return (votes[id]);        
    }
    
    function returnProposal(uint id) constant public returns (bytes32) {
        return (proposals[id]);        
    }

    function getWinner() public returns (bytes32 winner) {
        require(isOver());
        removeOwnership();

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

    function isOver() constant private returns (bool over) {
        if (startTime + votingTime > now) {
            return true;
        }
        return false;
    }

}
