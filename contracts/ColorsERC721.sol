pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract ColorsERC721 is ERC721Token, Ownable {
  string constant public NAME = "COLORS";
  string constant public SYMBOL = "HEX";

  uint256 constant public PRICE = .001 ether;

  mapping(uint256 => uint256) tokenToPriceMap;

  function ColorsERC721() public {

  }

  function name() public pure returns(string) {
    return NAME;
  }

  function symbol() public pure returns(string) {
    return SYMBOL;
  }

  function mint(uint256 colorId) public payable {
    require(msg.value >= PRICE);
    _mint(msg.sender, colorId);
    tokenToPriceMap[colorId] = PRICE;

    if (msg.value > PRICE) {
      uint256 priceExcess = msg.value - PRICE;
      msg.sender.transfer(priceExcess);
    }
  }

  function claim(uint256 colorId) public payable onlyMintedTokens(colorId) {
    uint256 askingPrice = getClaimingPrice(colorId);
    require(msg.value >= askingPrice);
    clearApprovalAndTransfer(ownerOf(colorId), msg.sender, colorId);
    tokenToPriceMap[colorId] = askingPrice;
  }

  function getClaimingPrice(uint256 colorId) public view onlyMintedTokens(colorId) returns(uint256){
    uint256 currentPrice = tokenToPriceMap[colorId];
    uint256 askingPrice = (currentPrice * 50) / 100;
    return askingPrice;
  }

  modifier onlyMintedTokens(uint256 colorId) {
    require (tokenToPriceMap[colorId] != 0);
    _;
  }
}