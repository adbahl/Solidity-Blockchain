/* Backend of the voting application based on blockchain, 
Application is used by friend to vote on where to have lunch.

****************************************************************
A smart contract which is deployed to the public Ethereum Testnet (Rinkeby).

1. The contract creator is able to add n choices
2. Only the contract creator is able to add n choices via deployed contract
3. The contract creator is able to select m friends to vote for n
4. Only the contract creator is be able to add m friends via deployed contract
5. Contract creator shall set q quorum.
6. Anyone can list out all the added choices.
7. Each selected friend can only vote once.
8. The contract stops accepting vote when q is met
9. Anyone can call the getResult() function to get the result of the poll
10. The creator can destroy the smart contract after the poll

Extension:
The extension can be transferring ethers as a share for lunch.
For example a single person might have paid for the lunch,
and now everyone will transfer the ethers to payee.
Creator can add the address of the payee, so variable will be payee
Function addpayee(address) -> this will add the address of person to whom payment need to be made.
Second function will be adding the amount of share per person will pay. assuming equal contribution.
The above function can be executed by only creator.
Function addshare(uint)-> This function can be executed by creator only.
Next function will be to getshare() this can be executed by all the friends added by creator.
After this we need to add function for payment, before which we will add variable which is amount left.
So the function payment(ether) can be executed by friends and will pay to friend who made payment.
Next the contract can only be destroyed once the payment amount is zero or less than that.
Also we can have more checks like if the input string already exits throw a message.
Also we can check if the input is empty in case of any function do not add the empty string and throw message
by using modifier to set require or assert or throw.

*****************************************************************
Contract id: 0xd585b6a9420c2ae5a9b4a46079ace041eac28d488f72f77f50860a034bb9eb65

Created By Arvind Bahl
*/

// Compiler version
pragma solidity 0.4.18;

//Contract
contract LunchVote{

 // Variables   
    struct optionsStruct{
        string restName;
        uint votes;
    }
    mapping (uint => optionsStruct) optionsMap;
    uint lenmap = 0;
    string[]  resturantnames = new string [] (lenmap);
    uint qValue =3;
    struct addValue{
        bool addedin;
        bool voted;
    }
    mapping (address => addValue) addressbook;
    address private owner;
    uint private totalVotes =0;
    
// Constructor function
    function LunchVote() public{
        owner = msg.sender;
        addfriend(owner);
    }
    
// modifier to keep a check, that only woner can execute a function.

    modifier powerCheck {
        require (owner == msg.sender);
        _;    
    }
    
// modifier to keep a check  that sender is a friend and has not voted.

    modifier powerCheck1 {
        require(addressbook[msg.sender].addedin ==true && addressbook[msg.sender].voted ==false && totalVotes<qValue);
        _;    
    }

// function to add choices   
    function addchoices(string memory _restname) public powerCheck {
        
        var addop = optionsMap[lenmap+1];
        addop.restName = _restname;
        addop.votes =0;
        lenmap++;
        
    }

//function to conconate two strings    
    function strConcat(string memory firstString, string memory secondString) internal pure returns (string memory){
        bytes memory _bfirstString = bytes(firstString);
        bytes memory _bsSecond = bytes(secondString);
        string memory _tstring1 = new string(_bfirstString.length + _bsSecond.length);
        bytes memory _bstring1 = bytes(_tstring1);
        uint k = 0;
        for (uint i = 0; i < _bfirstString.length; i++){
            _bstring1[k++] = _bfirstString[i];
        }
        for (uint j = 0; j < _bsSecond.length; j++){
            _bstring1[k++] = _bsSecond[j];
            
        }

    return string(_bstring1);
}

// function to add friends to addressbook

    function addfriend(address _addfriend) public powerCheck {
        
        addressbook[_addfriend].addedin = true;
        addressbook[_addfriend].voted = false;
    } 

// function to get choices, this functions takes more gas and time to execute.   
// This function takes time around 20 seconds for three to four choices, if after executing the function we click anywhere on remix, the remix might crash, this is bug in remix.
    function getchoices() public view returns (string memory) {
        
        string memory totalstring = "Choices are :- ";
        for (uint i=1; i < lenmap+1; i++) {
            var tempmap = optionsMap[i];
            string memory temstring = strConcat(" , ", tempmap.restName);
            totalstring = strConcat(totalstring, temstring);
        }
        return totalstring;
        
    } 
    
// function to modify the quorum, which has default value of 3, and only contract owner can set it.
    function setquorum (uint _qvalue) public powerCheck {
        
        qValue = _qvalue;
        
    } 
    
// function to cast the votes
    function castVotes(string vote) public powerCheck1{

        for (uint i =1; i < lenmap+1; i++) {
            
            var tempmap = optionsMap[i];
            if(keccak256(tempmap.restName) == keccak256(vote)){
                tempmap.votes++;
                totalVotes++;
                addressbook[msg.sender].voted = true;
                return;
            }
        }        
        
    }
    
// function to get the result. Can be called anytime, even if there is no vote casted. This is because anytime we should know the status. 
// In case of tie the first option in map will win.
    function getResult() public view returns(string memory){
        
        string memory winner = "No one voted yet";
        uint votecount =0;
        for (uint i =1; i < lenmap+1; i++) {
            
            var tempmap = optionsMap[i];
            if(tempmap.votes>votecount){
                winner = tempmap.restName;
                votecount = tempmap.votes;
            }
        }
        
        return winner;
        
    } 
//function will destroy the contract.   
        function destroyContract() public powerCheck { 
        if (msg.sender == owner)
        {
            selfdestruct(owner);  
        }
    }

}