// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Params {
    bool public initialized;

    // System contracts
    address payable
        public constant ValidatorContractAddr = payable(0x000000000000000000000000000000000000f000);
    address
        public constant PunishContractAddr = 0x000000000000000000000000000000000000F001;
    address
        public constant ProposalAddr = 0x000000000000000000000000000000000000F002;

// System params
    uint16 public constant MaxValidators = 1000;
    // Validator have to wait StakingLockPeriod blocks to withdraw staking
    uint64 public constant StakingLockPeriod = 86400;
    // Validator have to wait WithdrawProfitPeriod blocks to withdraw his profits
    uint64 public constant WithdrawProfitPeriod = 28800;
    uint256 public constant MinimalStakingCoin = 50 ether;
    // minimum initial staking to become a validator
    uint256 public constant minimumValidatorStaking = 500000 ether;


    // percent distrubution of Gas Fee earned by validator 100000 = 100%

    uint public constant burnPartPercent = 50000;                //50%
    uint public constant contractPartPercent = 50000;        //50%
    uint public constant burnStopAmount = 50000000 ether;      // after 500,000 coins burn, it will stop burning
    uint public totalBurnt;
    // extraRewardsPerBlock will be half after every half distribution of rewardFund.
    uint256 public extraRewardsPerBlock = 5 ether;  //  extra rewards will be added for distrubution
    uint256 public rewardFund;
    uint256 public lastReferenceValueRF = 100000000 ether; // reference to check next half
    uint256 public totalRewards;



    modifier onlyMiner() {
        require(msg.sender == block.coinbase, "Miner only");
        _;
    }

    modifier onlyNotInitialized() {
        require(!initialized, "Already initialized");
        _;
    }

    modifier onlyInitialized() {
        require(initialized, "Not init yet");
        _;
    }

    modifier onlyPunishContract() {
        require(msg.sender == PunishContractAddr, "Punish contract only");
        _;
    }

    modifier onlyBlockEpoch(uint256 epoch) {
        require(block.number % epoch == 0, "Block epoch only");
        _;
    }

    modifier onlyValidatorsContract() {
        require(
            msg.sender == ValidatorContractAddr,
            "Validators contract only"
        );
        _;
    }

    modifier onlyProposalContract() {
        require(msg.sender == ProposalAddr, "Proposal contract only");
        _;
    }
}
