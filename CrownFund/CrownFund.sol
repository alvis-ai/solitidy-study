// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

interface IERC20 {
    function transfer(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
}

contract CrownFund {
    event Launch(uint id, address indexed creator, uint goal, uint32 startAt, uint32 endAt);
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint indexed id, address indexed caller, uint balance);

    struct Compaign {
        address creator;
        uint goal;
        uint pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }

    IERC20 public immutable token;
    uint public count;
    mapping(uint => Compaign) public compaigns;
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    // 发起众筹
    function launch(uint _goal, uint32 _startOffset, uint32 _endOffset) external {
        require(_endOffset > _startOffset, "endAt <= startAt");
        require(_endOffset <= 30 days, "end > 30 days");
        uint32 _startAt = uint32(block.timestamp) + _startOffset;
        uint32 _endAt = uint32(block.timestamp) + _endOffset;
        count += 1;
        compaigns[count] = Compaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });
        emit Launch(count, msg.sender,_goal, _startAt, _endAt);
    }

    // 取消众筹
    function cancel(uint _id) external {
        Compaign memory compaign = compaigns[_id];
        require(msg.sender == compaign.creator, "not creator");
        require(block.timestamp < compaign.startAt, "already started");
        delete compaigns[_id];
        emit Cancel(_id);
    }

    // 认捐资金
    function pledge(uint _id, uint _amount) external payable  {
        Compaign storage compaign = compaigns[_id];
        require(block.timestamp >= compaign.startAt, "not started");
        require(block.timestamp <= compaign.endAt, "aleady ended");

        compaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;

        token.transferFrom(msg.sender, address(this), _amount);
        emit Pledge(_id, msg.sender, _amount);
    }

    // 撤回认捐
    function unpledge(uint _id, uint _amount) external {
        Compaign storage compaign = compaigns[_id];
        require(block.timestamp <= compaign.endAt, "already end");
        compaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
        emit Unpledge(_id, msg.sender, _amount);
    }

    // 提取资金
    function claim(uint _id) external {
        Compaign storage compaign = compaigns[_id];
        require(block.timestamp > compaign.endAt, "not ended");
        require(msg.sender == compaign.creator, "not creator");
        require(compaign.pledged >= compaign.goal, "pledge < goal");
        require(!compaign.claimed, "claimed");

        token.transfer(msg.sender, compaign.pledged);
        emit Claim(_id);
    }


    // 失败退款
    function refund(uint _id) external {
        Compaign storage compaign = compaigns[_id];
        require(block.timestamp > compaign.endAt, "not ended");
        require(compaign.pledged < compaign.goal, "pledge >=  goal");

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);
        emit Refund(_id, msg.sender, bal);
    }

}