// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DAOVoting {
    struct Proposal {
        uint id;
        string description;
        uint voteCount;
        uint deadline;
        bool executed;
    }

    address public admin;
    uint public nextProposalId;
    mapping(address => bool) public members;
    mapping(uint => Proposal) public proposals;
    mapping(uint => mapping(address => bool)) public votes;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Only DAO members can vote");
        _;
    }

    constructor() {
        admin = msg.sender;
        members[msg.sender] = true; // Admin is also a member
    }

    function addMember(address _member) external onlyAdmin {
        members[_member] = true;
    }

    function createProposal(string calldata _description, uint _duration) external onlyMember {
        proposals[nextProposalId] = Proposal(
            nextProposalId,
            _description,
            0,
            block.timestamp + _duration,
            false
        );
        nextProposalId++;
    }

    function vote(uint _proposalId) external onlyMember {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp < proposal.deadline, "Voting has ended");
        require(!votes[_proposalId][msg.sender], "Already voted");

        votes[_proposalId][msg.sender] = true;
        proposal.voteCount++;
    }

    function executeProposal(uint _proposalId) external onlyAdmin {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.deadline, "Voting is still active");
        require(!proposal.executed, "Proposal already executed");

        // For demo: execute means marking as executed
        proposal.executed = true;
    }
}
