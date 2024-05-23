# Vesting-Contract

Vesting Contract is a Solidity smart contract that manages token vesting for three different roles: User, Partner, and Team. It allows the contract owner to start vesting, add beneficiaries for each role, and enables beneficiaries to claim their vested tokens according to a predefined vesting schedule.
Contract Overview
The Vesting Contract has the following roles and vesting schedules:

User: 50% of the total allocated tokens with a cliff of 10 months and a total vesting duration of 2 years.
Partner: 25% of the total allocated tokens with a cliff of 2 months and a total vesting duration of 1 year.
Team: 25% of the total allocated tokens with a cliff of 2 months and a total vesting duration of 1 year.

The contract owner is responsible for starting the vesting process and adding beneficiaries for each role before vesting starts. Once vesting has started, beneficiaries can claim their vested tokens according to the specified schedule.
Contract Features

Token Contract Integration: The VestingContract interacts with an ERC20 token contract to manage token allocations and transfers.
Vesting Start: The contract owner can start the vesting process by calling the startVesting function.
Beneficiary Addition: The contract owner can add beneficiaries for each role (User, Partner, and Team) using the addBeneficiary function. This function calculates the token allocation based on the specified percentage and assigns the appropriate vesting schedule based on the role.
Token Claiming: Beneficiaries can claim their vested tokens by calling the claimTokens function. The contract calculates the vested amount based on the elapsed time since the vesting start and the beneficiary's vesting schedule.
Event Emission: The contract emits events for vesting start (VestingStarted), beneficiary addition (BeneficiaryAdded), and token withdrawal (TokensClaimed). These events can be used for tracking and auditing purposes.

Contract Deployment and Usage
To deploy and use the VestingContract, follow these steps:

Deploy the Token Contract: Deploy an ERC20 token contract and obtain its address.
Deploy the VestingContract: Deploy the VestingContract by passing the ERC20 token contract address as a constructor argument.
Start Vesting: Call the startVesting function from the contract owner's address to start the vesting process.
Add Beneficiaries: Call the addBeneficiary function from the contract owner's address to add beneficiaries for each role (User, Partner, and Team). Provide the beneficiary address, token allocation percentage, and the appropriate role flag (isUser).
Claim Tokens: Beneficiaries can call the claimTokens function to claim their vested tokens according to the vesting schedule.

Contract Events
The Vesting Contract emits the following events:

VestingStarted(uint256 startTime): Emitted when the vesting process is started, providing the start timestamp.
BeneficiaryAdded(address beneficiary, uint256 allocation, bool isUser): Emitted when a beneficiary is added, providing the beneficiary address, token allocation percentage, and the role flag (isUser).
TokensClaimed(address beneficiary, uint256 amount): Emitted when a beneficiary claims their vested tokens, providing the beneficiary address and the amount of tokens claimed.

Contract Dependencies
The VestingContract relies on the following OpenZeppelin contract:

@openzeppelin/contracts/token/ERC20/IERC20.sol: This contract provides an interface for ERC20 token contracts, which is used by the VestingContract to interact with the token contract.

Make sure to install the required dependencies before deploying and using the VestingContract.
Security Considerations
While this contract provides a basic implementation of a vesting system, it does not include advanced security features or thorough input validation. It is recommended to conduct thorough security audits and add additional safeguards before deploying the contract in a production environment.
Additionally, ensure that the contract owner is a trusted entity, as they have the ability to start vesting and add beneficiaries.
License
This smart contract is released under the MIT License.
