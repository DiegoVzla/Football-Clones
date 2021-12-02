// SPDX-License-Identifier: MIT
pragma solidity >=0.5.12;

import "./IERC721.sol";
import "./IERC721Receiver.sol";

contract Ballercontract is IERC721 {

event _Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

event Birth(address owner, uint256 newBallerId, uint256 mumId, uint256 dadId, uint256 genes);

// event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

//event ApprovalForAll(address indexed owner, address indexed operator, bool approved);


    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;


    uint256 public constant CREATION_LIMIT_GEN0 = 10;
    string public constant tknName = "ballerToken";
    string public constant tknSymbol = "BTK";

     address public owner;
    function Ownable() private {
    owner = msg.sender;
  }

    modifier onlyOwner{
    require(msg.sender == owner);
    _;
}

    struct Baller {
        uint256 genes;
        uint64 birthTime;
        uint32 mumId;
        uint32 dadId;
        uint16 generation;
    }

    Baller [] ballers;

    mapping (address => uint256) ownershipTokenCount;
    mapping (uint256 => address) public ballerIndexToOwner;

    mapping (uint256 => address) public ballerIndexToApproved;
    //Myaddr => operatorAddr => true/false
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    uint256 public gen0Counter;

    bytes4 internal constant MAGIC_ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));

    function mix(uint256 _dadId, uint256 _mumId) public returns (uint256) {
        require(owns(msg.sender, _dadId), "The user doesn't own the token");
        require(owns(msg.sender, _mumId), "The user doesn't own the token");

        (uint256 dadDna,,,,uint256 DadGeneration ) = getBaller(_dadId);
        (uint256 mumDna,,,,uint256 MumGeneration ) = getBaller(_dadId);
        uint256 newDna = _mixDna(_dadId, _mumId);

        uint kidGen = 0;
        if (DadGeneration < MumGeneration) {
            kidGen = MumGeneration + 1;
            kidGen /=2;
        } else if (DadGeneration > MumGeneration) {
            kidGen = DadGeneration + 1;
            kidGen /=2;
    } else {
        kidGen = MumGeneration + 1;
    }

    _createBaller(_mumId, _dadId, kidGen, newDna, msg.sender);

    }

    function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
        return (_interfaceId == _INTERFACE_ID_ERC721 || _interfaceId == _INTERFACE_ID_ERC165);
    }

    function safeTransferFrom(address _from,address  _to, uint256 _tokenId) public {
        safeTransferFrom(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from,address  _to, uint256 _tokenId, bytes memory _data) public {
        require(_to != address(0));
          require(owns(_from, _tokenId));
          require(msg.sender == _from || approvedFor(msg.sender, _tokenId) || isApprovedForAll(_from, msg.sender));
          require(_tokenId < ballers.length);

        safeTransferFrom(_from, _to, _tokenId, _data);
    }

    function _safeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) internal {
        _transfer(_from, _to, _tokenId);
        require(_checkERC721Support(_from, _to, _tokenId, _data));
    }

    function createBallerGen0 (uint256 _genes) public returns(uint256) {
        require(gen0Counter < CREATION_LIMIT_GEN0);
        gen0Counter++;

        return _createBaller(0, 0, 0, _genes, msg.sender);
    
    }

    function getBaller(uint256 _id) public view returns (
         uint256 genes,
        uint256 birthTime,
        uint256 mumId,
        uint256 dadId,
        uint256 generation
    ) {

        Baller storage baller = ballers[_id];
        birthTime =uint256(baller.birthTime);
        mumId = uint256(baller.mumId);
        dadId = uint256(baller.dadId);
        generation = uint256(baller.generation);
        genes = baller.genes;



    }

    function _createBaller (
        uint256 _mumId,
        uint256 _dadId,
        uint256 _generation,
        uint256 _genes,
        address _owner
    ) private returns (uint256) {
        Baller memory _baller = Baller ({
            genes: _genes,
            birthTime: uint64(block.timestamp),
            mumId: uint32(_mumId),
            dadId: uint32(_dadId),
            generation: uint16(_generation)
        });

        ballers.push(_baller);
        uint256 newBallerId = ballers.length - 1;
        emit Birth(_owner, newBallerId, _mumId, _dadId, _genes);

        _transfer(address(0), _owner, newBallerId);
        return newBallerId;
    }

     function name() external view returns (string memory tokenName) {
    }
    function symbol() external view returns (string memory tokenSymbol) {
    }


function balanceOf(address owner) external view returns (uint256 balance) {
    return ownershipTokenCount[owner];
}

/* @dev Returns the total number of tokens in circulation.
     */
    function totalSupply() external view returns (uint256 total) {
        return ballers.length;
    }
   
    
    
    function ownerOf(uint256 _tokenId) external view returns (address) {
        return ballerIndexToOwner[_tokenId];

    }

    function owns(address claimant, uint256 _tokenId) internal view returns (bool) {
        return ballerIndexToOwner[_tokenId] == claimant;
    }
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        ownershipTokenCount[_to]++;
        ballerIndexToOwner[_tokenId] = _to;
        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            delete ballerIndexToApproved[_tokenId];
             emit _Transfer (_from, _to, _tokenId);
        }
        
    }

    function transfer(address _to, uint256 _tokenId) external {
         require(_to != address(0));
        require(_to != address(this));
        require(owns(msg.sender, _tokenId));
         _transfer(msg.sender, _to, _tokenId);
        
    }

    
    function approve(address _to, uint256 _tokenId) external {
         require(owns(msg.sender, _tokenId));

        
        _approve(_tokenId, _to);

  
        emit Approval(msg.sender, _to, _tokenId);
    }

    function setApprovalForAll(address operator, bool approved) external {
        require(operator != msg.sender);

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);

    }

    function getApproved(uint256 tokenId) external view returns (address) {
         require(tokenId < ballers.length);
        return ballerIndexToApproved[tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
       return _operatorApprovals[owner][operator];
    
    }


function approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
    return ballerIndexToApproved[_tokenId] == _claimant;
}

     function _approve(uint256 _tokenId, address _approved) internal {
        ballerIndexToApproved[_tokenId] = _approved;
    }
     function transferFrom(address _from, address _to, uint256 _tokenId) external {
         require(_to != address(0));
          require(owns(_from, _tokenId));
          require(msg.sender == _from || approvedFor(msg.sender, _tokenId) || isApprovedForAll(_from, msg.sender));
    
          require(_tokenId < ballers.length);
        _transfer(_from, _to, _tokenId);
}

function _checkERC721Support(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool) {
  if( !_isContract(_to)){
      return true;
  }

  bytes4 returnData = IRC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
  return returnData == MAGIC_ERC721_RECEIVED;

}
 
function _isContract (address _to) view internal returns (bool) {
    uint32 size;
    assembly{
        size := extcodesize(_to)
    }
    return size > 0;
}

function _mixDna(uint256 _dadDna, uint256 _mumDna) internal returns (uint256) {
    //dadDna: 11 22 33 44 55 66 77 88
    //mumDna: 88 99 66 55 44 33 22 11

    uint256 firstHalf = _dadDna / 1000; //11223344
    uint256 secondHalf = _mumDna % 1000; //88776655
    uint newDna = firstHalf * 1000;
    newDna = newDna + secondHalf;
    return newDna;

    //11 22 33 44 88 77 66 55
}

}