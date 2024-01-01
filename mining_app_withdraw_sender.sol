//SPDX-License-Identifier: MIT
pragma solidity 0.8.23; 



//*******************************************************************//
//------------------ Contract to Manage Ownership -------------------//
//*******************************************************************//
contract owned
{
    address public owner;
    mapping(address => bool) public signer;

    event OwnershipTransferred(address indexed _from, address indexed _to);
    event SignerUpdated(address indexed signer, bool indexed status);

    constructor() {
        owner = msg.sender;
        //owner does not become signer automatically.
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }


    modifier onlySigner {
        require(signer[msg.sender], 'caller must be signer');
        _;
    }


    function changeSigner(address _signer, bool _status) public onlyOwner {
        signer[_signer] = _status;
        emit SignerUpdated(_signer, _status);
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }


}



    
//****************************************************************************//
//---------------------        MAIN CODE STARTS HERE     ---------------------//
//****************************************************************************//
    
contract Mining_App_Sender is owned {
    
    
    bool public bridgeStatus = true;

    // This generates a public event of coin received by contract
    event CoinOut(uint256 indexed orderID, address indexed user, uint256 value);
    event CoinOutFailed(uint256 indexed orderID, address indexed user, uint256 value);
   

    constructor () {
        //no specific code execution
    }
    
    receive () external payable {
        //nothing happens for incoming fund
    }
    
    
    
    function coinOut(address[] memory wallets, uint256[] memory amounts, uint256 batchId) external onlySigner returns(bool){
        
        uint256 walletsLength = wallets.length;
        
        require(bridgeStatus, "Bridge is inactive");
        require(walletsLength == amounts.length, "Both arrays must have an equal length");
        require(walletsLength <= 100, "Batch must have max 100 wallets");

        for(uint8 i = 0; i < walletsLength; i++){
            if(!isContract(wallets[i])){
                payable(wallets[i]).transfer(amounts[i]);
                emit CoinOut(batchId, wallets[i], amounts[i]);
            }  
            else{
                // we can not give coins to smart contract address through this way, to avoid any reentrancy attacks.
                emit CoinOutFailed(batchId, wallets[i], amounts[i]);
            }
        }
        return true;
    }
    
    

    function changeBridgeStatus(bool _bridgeStatus) external onlyOwner returns( string memory){
        bridgeStatus = _bridgeStatus;
        return "Bridge status updated";
    }

    function isContract(address _addr) public view returns (bool){
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    

}
