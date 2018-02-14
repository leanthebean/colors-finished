pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol'; 

contract ColorsERC721 is ERC721Token, Ownable { 
  string public constant NAME = "COLORS";
  string public constant SYMBOL = "HEX"; // RGB

  uint256 public constant PRICE = 0.001 ether;

  // Mapping from id to owner to track uniqueness 
  mapping(uint256 => uint256) private tokensToAddress;

  function ColorsERC721() public {

  }

  function name() public pure returns (string) { 
    return NAME;
  }

  function symbol() public pure returns(string) { 
    return SYMBOL; 
  }

  function mint(uint256 hexValue) public payable onlyUnique(hexValue) { 
    require(msg.value >= PRICE);
    ERC721Token._mint(msg.sender, hexValue);
    
    if (msg.value > PRICE) {
      uint256 priceExcess = msg.value - PRICE;
      msg.sender.transfer(priceExcess);
    }
  }

  modifier onlyUnique(uint256 hexValue) { 
    require(tokensToAddress[hexValue] == 0);
    _;
  }
}

