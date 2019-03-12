/* A getter and setter program to set and get string and uint value in Solidity.
Created By Arvind Bahl 13/3/2019
*/


pragma solidity 0.4.18;

contract Message{
    
    
    string private name;
    uint private age;
    
    function setname(string newname) {
        
        name = newname;
    }
    
    function getname() returns (string) {
        
        return name;
        
    }
    
    function setage(uint newage){
        
        age = newage;
    }
    
    function getage() returns (uint){
        
        return age;
    }
    
    
}