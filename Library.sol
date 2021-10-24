// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.6.0;
import "./Ownable.sol";
pragma experimental ABIEncoderV2;

contract Library is Ownable{
    
    
    struct Book {
        string name;
        uint copies;
    }
    
    struct addressBorrowedBook{
        address addr;
        uint bookid;
        bool isReturned;
    }
    
    Book[] public books;
    addressBorrowedBook[] public borrowedBooks;
    
    mapping (uint => string) idToBook;
    mapping (string => uint) bookAndCopies;
    
    
    function _addBook (string memory _name, uint _count) public onlyOwner{
        uint id = books.push(Book(_name, _count)) -1;
        idToBook[id] = _name;
        bookAndCopies[_name] = _count;
    }
    
    function borrowBook (uint id) public{
        require(books[id].copies > 0, "Not enought book to borrow");
        require(dontAllowBorrowingSameBookTwice(id) == true);
        books[id].copies = books[id].copies -1;
        borrowedBooks.push(addressBorrowedBook(msg.sender, id, false));
    }
    
    function returnBook (uint id) public {
        require(checkIfAddressHasBorowedBook(id) == true);
        books[id].copies = books[id].copies  +1;
        
    }
    
    function showAvailableBooks() public view returns(string[] memory){
        string[] memory result = new string[](books.length);
        uint counter = 0;
        for (uint i = 0; i < books.length; i++ ){
            string memory res = books[i].name;
            result[counter] = res;
            counter++;
            
        }
        return result;
        
    }
    
    function dontAllowBorrowingSameBookTwice(uint bookid) public returns (bool){
        
        for (uint i = 0; i < borrowedBooks.length; i++ ){
            if (borrowedBooks[i].addr == msg.sender && borrowedBooks[i].bookid == bookid && borrowedBooks[i].isReturned == false){
                return false;
            } 
        }
        return true;
    }
    
    
    function checkIfAddressHasBorowedBook(uint bookid) public returns (bool){
        
        for (uint i = 0; i < borrowedBooks.length; i++ ){
            if (borrowedBooks[i].addr == msg.sender && borrowedBooks[i].bookid == bookid && borrowedBooks[i].isReturned == false){
                borrowedBooks[i].isReturned = true;
                return true;
            }
        }
    }
    
    
    function showAllAddressesByBorrowedBook(uint _id) public view returns(address[] memory){
        address[] memory result = new address[](borrowedBooks.length);
        uint counter = 0;
        for (uint i = 0; i < borrowedBooks.length; i++ ){
            if (borrowedBooks[i].bookid == _id){
                address adr = borrowedBooks[i].addr;
                result[counter] = adr;
                counter++;
            }
        }
        return result;
    }

}
