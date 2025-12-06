// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint256 balance); 
    function ownerOf(uint256 tokenId) external view returns (address owner); 
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external; 
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external; 
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

contract ERC721 is IERC721 {
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;


    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return interfaceId == type(IERC165).interfaceId || interfaceId == type(IERC721).interfaceId;
    }

    function balanceOf(address owner) external view virtual override returns (uint256 balance){
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public  view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: balance query for the zero address");
        return owner;
    }

    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint tokenId
    ) internal view returns (bool) {
        return (spender == owner 
        || isApprovedForAll(owner, spender)
        || spender == _tokenApprovals[tokenId]);
    }


    function transferFrom(address from, address to, uint256 tokenId) public  {
        require(from == ownerOf(tokenId), "from != owner");
        require(to != address(0), "to == zero address");
        require(_isApprovedOrOwner(from, msg.sender, tokenId), "not authrized");
        _balances[from] --;
        _balances[to] ++;
        _owners[tokenId] = to;
        delete _tokenApprovals[tokenId];
        emit Transfer(from, to, tokenId);
    }


    function safeTransferFrom(address from, address to, uint256 tokenId) external {
        transferFrom(from, to, tokenId);
        require(to.code.length == 0 || IERC721Receiver(to).onERC721Received(from, to, tokenId, "") == IERC721Receiver.onERC721Received.selector, "unsafe receipt");
    }

    function approve(address to, uint256 tokenId) public virtual override  {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approve to current owner");
        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all"
        );
        
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) external view returns (address operator) {
        require(_owners[tokenId] != address(0), "tokenId does not exist");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool _approved) external {
        _operatorApprovals[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }

    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external {
        transferFrom(from, to, tokenId);
        require(to.code.length == 0 || IERC721Receiver(to).onERC721Received(from, to, tokenId, data) == IERC721Receiver.onERC721Received.selector, "unsafe receipt");

    }

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _mint(address to, uint256 tokenId) internal  {
        require(to != address(0), "to = address(0");
        require(_owners[tokenId] == address(0), "token exists");
        _balances[to] ++;
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal {
        address owner = _owners[tokenId];
        require(owner != address(0), "token does not exist");
        _balances[owner] --;
        delete _owners[tokenId];
        delete _tokenApprovals[tokenId];
        emit Transfer(owner, address(0), tokenId);

    }
}

contract MyNFT is ERC721  {
    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }

    function burn(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId), "not owner");
        _burn(tokenId);
    }
}