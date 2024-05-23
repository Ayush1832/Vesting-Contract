
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VestingContract {
    
    IERC20 public tokenContract;

    
    address public owner;

    
    mapping(address => Allocation) public allocations;

   
    struct Allocation {
        uint256 totalAllocation; 
        uint256 vestedAmount; 
        uint256 cliff; 
        uint256 duration; 
        uint256 startTime; 
        bool isUser; 
    }


    event VestingStarted(uint256 startTime);
    event BeneficiaryAdded(address beneficiary, uint256 allocation, bool isUser);
    event TokensClaimed(address beneficiary, uint256 amount);

 
    constructor(IERC20 _tokenContract) {
        tokenContract = _tokenContract;
        owner = msg.sender;
    }

   
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

   
    function startVesting() external onlyOwner {
        require(allocations[owner].startTime == 0, "Vesting already started");
        allocations[owner].startTime = block.timestamp;
        emit VestingStarted(block.timestamp);
    }

  
    function addBeneficiary(address beneficiary, uint256 allocation, bool isUser, uint256 cliff, uint256 duration) external onlyOwner {
        require(allocations[owner].startTime != 0, "Vesting not started yet");
        require(allocations[beneficiary].totalAllocation == 0, "Beneficiary already added");

        uint256 totalTokens = tokenContract.totalSupply();
        uint256 cliffPeriod = isUser ? 10 * 30 days : 2 * 30 days;
        uint256 vestingDuration = isUser ? 63072000 seconds: 31536000 seconds; //time in seconds

        allocations[beneficiary] = Allocation({
            totalAllocation: allocation * totalTokens / 100,
            vestedAmount: 0,
            cliff: cliffPeriod,
            duration: vestingDuration,
            startTime: allocations[owner].startTime,
            isUser: isUser
        });

        emit BeneficiaryAdded(beneficiary, allocation, isUser);
    }

   
    function claimTokens() external {
        Allocation storage allocation = allocations[msg.sender];
        require(allocation.totalAllocation > 0, "No allocation for the beneficiary");

        uint256 availableTokens = calculateVestedTokens(msg.sender);
        require(availableTokens > 0, "No tokens vested yet");

        allocation.vestedAmount += availableTokens;
        require(tokenContract.transfer(msg.sender, availableTokens), "Token transfer failed");

        emit TokensClaimed(msg.sender, availableTokens);
    }

    function calculateVestedTokens(address beneficiary) internal view returns (uint256) {
        Allocation memory allocation = allocations[beneficiary];

        if (block.timestamp < allocation.startTime + allocation.cliff) {
            return 0;
        }

        uint256 elapsedTime = block.timestamp - allocation.startTime;
        uint256 vestedTokens = allocation.totalAllocation * elapsedTime / allocation.duration;

        return vestedTokens - allocation.vestedAmount;
    }
}
