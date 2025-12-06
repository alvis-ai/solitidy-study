// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint nftId
    ) external;
}


contract EnglishAuction {
    event Start();
    event Bid(address indexed bider, uint256 bid);
    event Withdraw(address indexed bider, uint bid);
    event End(address indexed highestBider, uint highestBid);

    // NFT信息
    IERC721 public nft;
    uint public nftId;

    // 拍卖信息
    uint public immutable startingPrice;
    address payable private immutable seller;
    bool public started;
    bool public ended;
    uint32 endAt;


    uint public highestBid;
    address public highestBidder;
    mapping(address => uint) bids;

    // 初始化
    constructor(
        address _nft,
        uint _nftId,
        uint _startingPrice
    ) {
        seller = payable (msg.sender);
        nft = IERC721(_nft);
        nftId = _nftId;
        startingPrice = _startingPrice;
        highestBid = _startingPrice;
    }
    
    // 卖家发起竞拍
    function start() external {
        require(msg.sender == seller, "not seller");
        require(!started, "alreay started");

        started = true;
        endAt = uint32(block.timestamp + 60);
        nft.transferFrom(seller, address(this), nftId);
        emit Start();
    }

    // 买家竞拍
    function bid() external payable {
        require(started, "not started");
        require(endAt > block.timestamp, "ended");
        require(msg.value > highestBid, "ETH < highest bid");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit Bid(msg.sender, msg.value);
    }

    // 买家提款
    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable (msg.sender).transfer(bal);
        emit Withdraw(msg.sender, bal);
    }

    // 结束拍卖
    function end() external {
        require(started, "not start");
        require(!ended, "ended");
        require(block.timestamp >= endAt, "not ended");
        ended = true;
        if (highestBidder != address(0)) {
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.transferFrom(address(this), seller, nftId);
        }
        emit End(highestBidder, highestBid);
    }
}