// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint nftId
    ) external;
}

contract DutchAuction {
    // NFT 相关信息
    IERC721 public immutable nft;
    uint public immutable nftId;

    // 拍卖信息
    uint private  constant DURATION = 7 days;
    address public  immutable seller;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiredAt;
    uint public immutable discountRate;

    // 卖家出售 NFT
    constructor(
        uint _startingPrice,
        uint _discountRate,
        address _nft,
        uint _nftId
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expiredAt = block.timestamp + DURATION;

        require(startingPrice >= discountRate * DURATION, "starting price < discount");

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    // 买家购买 NFT
    function buy() external payable {
        require(block.timestamp < expiredAt, "auction expired");
        uint price = getPrice();
        require(msg.value > price, "ETH < price");
        nft.transferFrom(seller, msg.sender, nftId);
        uint refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
    }

    function getPrice() public view returns (uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }
}