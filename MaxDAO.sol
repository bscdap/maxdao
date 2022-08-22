// File: contracts/libs/IBEP20.sol

pragma solidity 0.5.12;

interface IBEP20 {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/libs/Context.sol

pragma solidity 0.5.12;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor() internal {}

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: contracts/libs/Ownable.sol

pragma solidity 0.5.12;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor () internal {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  /**
   * @dev Returns the address of the current owner.
   */
  function owner() public view returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  /**
   * @dev Leaves the contract without owner. It will not be possible to call
   * `onlyOwner` functions anymore. Can only be called by the current owner.
   *
   * NOTE: Renouncing ownership will leave the contract without an owner,
   * thereby removing any functionality that is only available to the owner.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

// File: contracts/libs/BaseMDC.sol

pragma solidity 0.5.12;

contract BaseMDC {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function mint(address _uid, uint256 _tokens) external returns (bool);

    function isUser(address _uid) external view returns (bool);

    function getInviter(address _uid) external view returns (address);

    function defaultInvite() external view returns (address);
}

// File: contracts/libs/SafeMath.sol

pragma solidity 0.5.12;


/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

// File: contracts/libs/IUniswapV2Factory.sol

pragma solidity 0.5.12;

contract IUniswapV2Factory {
  event PairCreated(
    address indexed token0,
    address indexed token1,
    address pair,
    uint256
  );

  function feeTo() external view returns (address);

  function feeToSetter() external view returns (address);

  function getPair(address _tokenA, address _tokenB)
    external
    view
    returns (address pair);

  function allPairs(uint256) external view returns (address pair);

  function allPairsLength() external view returns (uint256);

  function createPair(address _tokenA, address _tokenB)
    external
    returns (address pair);

  function setFeeTo(address) external;

  function setFeeToSetter(address) external;
}

// File: contracts/libs/IUniswapV2Router01.sol

pragma solidity 0.5.12;

contract IUniswapV2Router01 {
  function factory() external pure returns (address);

  function WETH() external pure returns (address);

  function getAmountOut(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountOut);

  function getAmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountIn);

  function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

  function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}

// File: contracts/libs/IUniswapV2Router02.sol

pragma solidity 0.5.12;

contract IUniswapV2Router02 is IUniswapV2Router01 {
  
}

// File: contracts/MaxDAO.sol

pragma solidity 0.5.12;







contract MaxDAO is Ownable {
    using SafeMath for uint256;

    struct Index {
        uint256 time;
        uint256 amount;
    }

    mapping(string => Index) internal _indexGlobal;

    struct MiningPool {
        uint256 limit;
        uint256 pledge;
        uint256 output;
        uint256 supply;
        uint256 surplus;
        bool enable;
    }

    mapping(string => MiningPool) internal _miningPools;

    struct MintPool {
        uint256 deposit;
        uint256 mintAmount;
        uint256 time;
    }

    mapping(string => MintPool) internal _mintPool;

    struct Token {
        address token;
        string symbol;
        uint256 decimal;
    }

    Token[] internal _tokenList;
    mapping(address => Token) internal _tokens;

    struct Order {
        address token;
        uint256 amount;
        uint256 pledge;
        string types;
        bool isWithdraw;
        uint256 time;
    }

    mapping(address => Order[]) internal _orders;

    struct Deposit {
        address token;
        uint256 amount;
    }

    mapping(string => mapping(address => Deposit[])) internal _deposits;
    mapping(string => Deposit[]) internal _depositTotal;
    mapping(string => mapping(address => uint256)) internal _timeLast;
    mapping(address => uint256) internal _profits;

    uint256 internal _timeEnable;
    uint256 internal _timedate;

    uint256 internal _rateSafe = 30;

    IUniswapV2Router02 internal _v2Router;
    BaseMDC internal _MDC;

    address internal _usdtAddr;
    address internal _safeAddr;
    address internal _mdcAddr;
    address internal _safeLP;
    address internal _mdcLP;

    constructor(
        address _router,
        address _safe,
        address _mdc,
        address _usdt,
        uint256 _time
    ) public {
        _v2Router = IUniswapV2Router02(_router);
        _usdtAddr = _usdt;
        _safeAddr = _safe;
        _mdcAddr = _mdc;
        _MDC = BaseMDC(_mdc);
        _timedate = _time;

        _miningPools["alone"] = MiningPool(
            2000e18,
            0,
            200e18,
            30000e18,
            30000e18,
            true
        );
        _miningPools["compose"] = MiningPool(
            0,
            0,
            400e18,
            200000e18,
            200000e18,
            false
        );
        _miningPools["safelp_30"] = MiningPool(
            0,
            0,
            96e18,
            60000e18,
            60000e18,
            true
        ); // LP - SAFE
        _miningPools["safelp_90"] = MiningPool(
            0,
            0,
            144e18,
            90000e18,
            90000e18,
            true
        ); // LP - SAFE
        _miningPools["mdclp_30"] = MiningPool(
            0,
            0,
            240e18,
            150000e18,
            150000e18,
            true
        ); // LP - MDC
        _miningPools["mdclp_90"] = MiningPool(
            0,
            0,
            240e18,
            150000e18,
            150000e18,
            true
        ); // LP - MDC
        _miningPools["mdclp_360"] = MiningPool(
            0,
            0,
            320e18,
            200000e18,
            200000e18,
            true
        ); // LP - MDC
        _miningPools["safelp"] = MiningPool(
            0,
            0,
            960e18,
            150000e18,
            150000e18,
            false
        ); // LP
        _miningPools["mdclp"] = MiningPool(
            0,
            0,
            960e18,
            500000e18,
            500000e18,
            false
        ); // LP
    }

    function tokenPrice(address _tokenA) public view returns (uint256 price) {
        if (_tokenA == _usdtAddr) return 1e18;
        if (_tokenA == _safeLP) return 1e18;
        if (_tokenA == _mdcLP) return 1e18;
        address[] memory _path = new address[](2);
        _path[0] = _tokenA;
        _path[1] = _usdtAddr;
        uint256[] memory _amounts = _v2Router.getAmountsOut(
            10**_tokens[_tokenA].decimal,
            _path
        );
        return _amounts[1];
    }

    function addToken(
        address _token,
        string memory _symbol,
        uint256 _decimal
    ) public onlyOwner {
        _tokenList.push(Token(_token, _symbol, _decimal));
        _tokens[_token] = Token(_token, _symbol, _decimal);
    }

    function removeToken(address _token) public onlyOwner {
        Token[] memory _tmpTokens = _tokenList;
        delete _tokenList;
        delete _tokens[_token];
        for (uint256 i = 0; i < _tmpTokens.length; i++) {
            if (_tmpTokens[i].token != _token) {
                _tokenList.push(_tmpTokens[i]);
            }
        }
    }

    function transfer(
        address token,
        address recipient,
        uint256 amount
    ) public onlyOwner {
        IBEP20(token).transfer(recipient, amount);
    }

    function depositAlone(address _token, uint256 _amount) public {
        require(_MDC.isUser(msg.sender));
        require(_miningPools["alone"].enable);
        require(_tokens[_token].token != address(0));
        require(_tokens[_token].token != _safeLP);
        require(_tokens[_token].token != _mdcLP);
        require(
            IBEP20(_token).transferFrom(msg.sender, address(this), _amount)
        );
        string memory _type = "alone";
        if (_miningPools[_type].limit > 0) {
            uint256 depositValue = _depositValue(msg.sender, _type);
            uint256 currentValue = _amount.mul(tokenPrice(_token)).div(1e18);
            require(
                depositValue.add(currentValue) <= _miningPools[_type].limit
            );
        }
        uint256 _pledge = _miningPools[_type].pledge;
        _saveOrder(_token, _amount, _pledge, _type);
    }

    function depositCompose(
        address _token,
        uint256 _amount1,
        uint256 _amount2
    ) public {
        require(_MDC.isUser(msg.sender));
        require(_miningPools["compose"].enable);
        require(_tokens[_token].token != address(0));
        require(_tokens[_token].token != _safeLP);
        require(_tokens[_token].token != _mdcLP);
        require(
            IBEP20(_safeAddr).transferFrom(msg.sender, address(this), _amount1)
        );
        require(
            IBEP20(_token).transferFrom(msg.sender, address(this), _amount2)
        );

        Token memory _token1 = _tokens[_safeAddr];
        Token memory _token2 = _tokens[_token];

        uint256 _value1 = _amount1.mul(tokenPrice(_safeAddr)).div(
            10**_token1.decimal
        );
        uint256 _value2 = _amount2.mul(tokenPrice(_token)).div(
            10**_token2.decimal
        );

        require(_value1.mul(100).div(_value1.add(_value2)) <= _rateSafe.add(1));
        require(_value1.mul(100).div(_value1.add(_value2)) >= _rateSafe.sub(1));

        string memory _type = "compose";
        uint256 _pledge = _miningPools[_type].pledge;

        _saveOrder(_safeAddr, _amount1, _pledge, _type);
        _saveOrder(_token, _amount2, _pledge, _type);
    }

    function depositSafeLP(uint256 _amount, uint256 _pledge) public {
        require(_MDC.isUser(msg.sender));
        require(_miningPools["safelp"].enable);
        require(_pledge == 30 || _pledge == 90);
        require(
            IBEP20(_safeLP).transferFrom(msg.sender, address(this), _amount)
        );
        string memory _type;
        if (_pledge == 30) {
            _type = "safelp_30";
        } else {
            _type = "safelp_90";
        }

        _saveOrder(_safeLP, _amount, _pledge, _type);
    }

    function depositMdcLP(uint256 _amount, uint256 _pledge) public {
        require(_MDC.isUser(msg.sender));
        require(_miningPools["mdclp"].enable);
        require(_pledge == 30 || _pledge == 90 || _pledge == 360);
        require(
            IBEP20(_mdcLP).transferFrom(msg.sender, address(this), _amount)
        );
        string memory _type;
        if (_pledge == 30) {
            _type = "mdclp_30";
        } else if (_pledge == 90) {
            _type = "mdclp_90";
        } else {
            _type = "mdclp_360";
        }

        _saveOrder(_mdcLP, _amount, _pledge, _type);
    }

    function _saveOrder(
        address _token,
        uint256 _amount,
        uint256 _pledge,
        string memory _type
    ) internal {
        address _uid = _msgSender();
        if (_timeLast[_type][_uid] == 0) {
            _timeLast[_type][_uid] = _timedate;
        }
        _mintPool[_type].deposit += _amount;
        _mint(_uid, _type);
        _setDeposit(_token, _amount, _type, true);
        _orders[_uid].push(
            Order(_token, _amount, _pledge, _type, false, block.timestamp)
        );
    }

    function _setDeposit(
        address _token,
        uint256 _amount,
        string memory _type,
        bool _isDeposit
    ) internal {
        bool _exist;
        address _uid = _msgSender();

        Deposit[] memory _deposit = _deposits[_type][_uid];
        for (uint256 i = 0; i < _deposit.length; i += 1) {
            if (_deposit[i].token == _token) {
                _exist = true;
                if (_isDeposit) {
                    _deposits[_type][_uid][i].amount += _amount;
                } else {
                    _deposits[_type][_uid][i].amount -= _amount;
                }
                break;
            }
        }
        if (false == _exist) {
            _deposits[_type][_uid].push(Deposit(_token, _amount));
        }

        _exist = false;
        _deposit = _depositTotal[_type];
        for (uint256 i = 0; i < _deposit.length; i += 1) {
            if (_deposit[i].token == _token) {
                _exist = true;
                if (_isDeposit) {
                    _depositTotal[_type][i].amount += _amount;
                } else {
                    _depositTotal[_type][i].amount -= _amount;
                }
                break;
            }
        }
        if (false == _exist) {
            _depositTotal[_type].push(Deposit(_token, _amount));
        }
    }

    function depositValue(address _uid) public view returns (uint256) {
        uint256 _value;
        _value += depositValue(_uid, "alone");
        _value += depositValue(_uid, "compose");
        return _value;
    }

    function depositValue(address _uid, string memory _type)
        public
        view
        returns (uint256)
    {
        uint256 _value;
        if (
            keccak256(abi.encodePacked(_type)) ==
            keccak256(abi.encodePacked("lp"))
        ) {
            _value += _depositValue(_uid, "safelp_30");
            _value += _depositValue(_uid, "safelp_90");
            _value += _depositValue(_uid, "safelp_360");
            _value += _depositValue(_uid, "mdclp_30");
            _value += _depositValue(_uid, "mdclp_90");
            _value += _depositValue(_uid, "mdclp_360");
        } else {
            _value = _depositValue(_uid, _type);
        }
        return _value;
    }

    function depositValueLPSafe(address _uid) public view returns (uint256) {
        uint256 _value;
        _value += _depositValue(_uid, "safelp_30");
        _value += _depositValue(_uid, "safelp_90");
        return _value;
    }

    function depositValueLPMdc(address _uid) public view returns (uint256) {
        uint256 _value;
        _value += _depositValue(_uid, "mdclp_30");
        _value += _depositValue(_uid, "mdclp_90");
        _value += _depositValue(_uid, "mdclp_360");
        return _value;
    }

    function _depositValue(address _uid, string memory _type)
        internal
        view
        returns (uint256)
    {
        Deposit[] memory _deposit = _deposits[_type][_uid];
        uint256 _value;
        uint256 _price;
        uint256 _decimal;
        for (uint256 i = 0; i < _deposit.length; i++) {
            _price = tokenPrice(_deposit[i].token);
            _decimal = _tokens[_deposit[i].token].decimal;
            _value = _value.add(
                _deposit[i].amount.mul(_price).div(10**_decimal)
            );
        }
        return _value;
    }

    function _depositValueLP(address _uid, string memory _type)
        internal
        view
        returns (uint256)
    {
        Deposit[] memory _deposit = _deposits[_type][_uid];
        uint256 _value;
        for (uint256 i = 0; i < _deposit.length; i++) {
            _value = _value.add(_deposit[i].amount);
        }
        return _value;
    }

    function depositValueTotal(string memory _type)
        public
        view
        returns (uint256)
    {
        uint256 _value;
        if (
            keccak256(abi.encodePacked(_type)) ==
            keccak256(abi.encodePacked("lp"))
        ) {
            _value += _depositValueTotal("safelp_30");
            _value += _depositValueTotal("safelp_90");
            _value += _depositValueTotal("mdclp_30");
            _value += _depositValueTotal("mdclp_90");
            _value += _depositValueTotal("mdclp_360");
        } else {
            _value = _depositValueTotal(_type);
        }
        return _value;
    }

    function depositValueTotalLPSafe() public view returns (uint256) {
        uint256 _value;
        _value += _depositValueTotal("safelp_30");
        _value += _depositValueTotal("safelp_90");
        return _value;
    }

    function depositValueTotalLPMdc() public view returns (uint256) {
        uint256 _value;
        _value += _depositValueTotal("mdclp_30");
        _value += _depositValueTotal("mdclp_90");
        _value += _depositValueTotal("mdclp_360");
        return _value;
    }

    function _depositValueTotal(string memory _type)
        public
        view
        returns (uint256)
    {
        Deposit[] memory _deposit = _depositTotal[_type];
        uint256 _value;
        uint256 _price;
        uint256 _decimal;
        for (uint256 i = 0; i < _deposit.length; i++) {
            _price = tokenPrice(_deposit[i].token);
            _decimal = _tokens[_deposit[i].token].decimal;
            _value = _value.add(
                _deposit[i].amount.mul(_price).div(10**_decimal)
            );
        }
        return _value;
    }

    function _depositValueTotalLP(string memory _type)
        public
        view
        returns (uint256)
    {
        Deposit[] memory _deposit = _depositTotal[_type];
        uint256 _value;
        for (uint256 i = 0; i < _deposit.length; i++) {
            _value = _value.add(_deposit[i].amount);
        }
        return _value;
    }

    function withdrawToken(uint256 _key) public {
        Order memory _order = _orders[msg.sender][_key];
        require(!_order.isWithdraw);
        require(_mintAmount(msg.sender, _order.types) == 0);
        require(block.timestamp >= _order.time.add(_order.pledge.mul(86400)));

        _mint(msg.sender, _order.types);

        require(IBEP20(_order.token).transfer(msg.sender, _order.amount));
        _setDeposit(_order.token, _order.amount, _order.types, false);
        _mintPool[_order.types].deposit -= _order.amount;
        _orders[msg.sender][_key].isWithdraw = true;
    }

    function mintAmount(address _uid, string memory _type)
        public
        view
        returns (uint256)
    {
        return _mintAmount(_uid, _type);
    }

    function _mintAmount(address _uid, string memory _type)
        internal
        view
        returns (uint256)
    {
        MiningPool memory _miningPool = _miningPools[_type];
        uint256 _total = _indexGlobal[_type].amount;
        if (_total == 0) return 0;
        uint256 _value = _depositValue(_uid, _type);
        uint256 _days = mintDays(_uid, _type);
        uint256 _amount = _value.mul(_miningPool.output.div(2).mul(_days)).div(
            _total
        );
        if (_mintPool[_type].mintAmount < _amount) {
            _amount = _mintPool[_type].mintAmount;
        }
        return _amount;
    }

    function mint(string memory _type) public {
        if (
            keccak256(abi.encodePacked(_type)) ==
            keccak256(abi.encodePacked("safelp"))
        ) {
            _mint(msg.sender, "safelp_30");
            _mint(msg.sender, "safelp_90");
        } else if (
            keccak256(abi.encodePacked(_type)) ==
            keccak256(abi.encodePacked("mdclp"))
        ) {
            _mint(msg.sender, "mdclp_30");
            _mint(msg.sender, "mdclp_90");
            _mint(msg.sender, "mdclp_360");
        } else {
            _mint(msg.sender, _type);
        }
    }

    function _mint(address _uid, string memory _type) internal {
        _setDatetime();
        if (_miningPools[_type].surplus == 0) return;
        if (_mintPool[_type].mintAmount > 0) {
            uint256 _amount = _mintAmount(_uid, _type);
            if (_miningPools[_type].surplus < _amount) {
                _amount = _miningPools[_type].surplus;
            }
            _mintPool[_type].mintAmount -= _amount;
            _miningPools[_type].surplus -= _amount;
            _profits[_uid] = _profits[_uid].add(_amount.div(2));
            if (_amount > 0) {
                if (!_MDC.mint(_uid, _amount)) {
                    revert("mint fail");
                }
            }
        }
        _timeLast[_type][_uid] = _timedate;
    }

    function mintDays(address _uid, string memory _type)
        public
        view
        returns (uint256)
    {
        if (_timeLast[_type][_uid] == 0) return 0;
        return _timedate.sub(_timeLast[_type][_uid]).div(12 hours);
    }

    function getProfit(address _uid) public view returns (uint256) {
        return _profits[_uid];
    }

    function getListOrder(address _uid, uint256 _key)
        public
        view
        returns (
            uint256 index,
            address token,
            uint256 amount,
            uint256 pledge,
            string memory types,
            bool hasWithdraw,
            bool isWithdraw,
            uint256 time,
            uint256 total
        )
    {
        Order memory _order;
        uint256 _total = _orders[_uid].length;
        uint256 _index;
        if (_total > 0 && _key <= _total) {
            _index = _total.sub(_key);
            _order = _orders[_uid][_index];
        }

        bool _hasWithdraw = block.timestamp >=
            _order.time.add(_order.pledge.mul(86400)) &&
            _mintAmount(_uid, _order.types) == 0;

        if (_order.isWithdraw) {
            _hasWithdraw = false;
        }

        return (
            _index,
            _order.token,
            _order.amount,
            _order.pledge,
            _order.types,
            _hasWithdraw,
            _order.isWithdraw,
            _order.time,
            _total
        );
    }

    function getAllMinAmount(address _uid)
        public
        view
        returns (
            uint256 alone,
            uint256 compose,
            uint256 safelp,
            uint256 mdclp
        )
    {
        uint256 _alone = _mintAmount(_uid, "alone");
        uint256 _compose = _mintAmount(_uid, "compose");
        uint256 _safelp;
        uint256 _mdclp;
        _safelp += _mintAmount(_uid, "safelp_30");
        _safelp += _mintAmount(_uid, "safelp_90");

        _mdclp += _mintAmount(_uid, "mdclp_30");
        _mdclp += _mintAmount(_uid, "mdclp_90");
        _mdclp += _mintAmount(_uid, "mdclp_360");
        return (_alone, _compose, _safelp, _mdclp);
    }

    function getAllDepositTotal()
        public
        view
        returns (
            uint256 alone,
            uint256 compose,
            uint256 safelp,
            uint256 mdclp
        )
    {
        uint256 _alone = _depositValueTotal("alone");
        uint256 _compose = _depositValueTotal("compose");
        uint256 _lpSafe = depositValueTotalLPSafe();
        uint256 _lpMdc = depositValueTotalLPMdc();
        return (_alone, _compose, _lpSafe, _lpMdc);
    }

    function getAllDeposit(address _uid)
        public
        view
        returns (
            uint256 alone,
            uint256 compose,
            uint256 safelp,
            uint256 mdclp
        )
    {
        uint256 _alone = _depositValue(_uid, "alone");
        uint256 _compose = _depositValue(_uid, "compose");
        uint256 _safelp = depositValueLPSafe(_uid);
        uint256 _mdclp = depositValueLPMdc(_uid);
        return (_alone, _compose, _safelp, _mdclp);
    }

    function getSurplusMint()
        public
        view
        returns (
            uint256 alone,
            uint256 compose,
            uint256 safelp,
            uint256 mdclp
        )
    {
        uint256 _alone = _miningPools["alone"].surplus;
        uint256 _compose = _miningPools["compose"].surplus;
        uint256 _safelp;
        uint256 _mdclp;
        _safelp += _miningPools["safelp_30"].surplus;
        _safelp += _miningPools["safelp_90"].surplus;
        _mdclp += _miningPools["mdclp_30"].surplus;
        _mdclp += _miningPools["mdclp_90"].surplus;
        _mdclp += _miningPools["mdclp_360"].surplus;
        return (_alone, _compose, _safelp, _mdclp);
    }

    function datetime() public view returns (uint256) {
        return _timedate;
    }

    function getMiningPoolEnable()
        public
        view
        returns (
            bool alone,
            bool compose,
            bool safelp,
            bool mdclp
        )
    {
        bool _alone = _miningPools["alone"].enable;
        bool _compose = _miningPools["compose"].enable;
        bool _safelp = _miningPools["safelp"].enable;
        bool _mdclp = _miningPools["mdclp"].enable;
        return (_alone, _compose, _safelp, _mdclp);
    }

    function getMintPoolAmount(string memory _type)
        public
        view
        returns (
            uint256 amount,
            uint256 deposit,
            uint256 time
        )
    {
        return (
            _mintPool[_type].mintAmount,
            _mintPool[_type].deposit,
            _mintPool[_type].time
        );
    }

    function _setDatetime() internal returns (bool) {
        uint256 _time = _timedate;
        if (_time.add(12 hours) < block.timestamp) {
            do {
                _time = _time.add(12 hours);
            } while (_time.add(12 hours) < block.timestamp);
            _timedate = _time;
        }
        _setMintPool("alone");
        _setMintPool("compose");
        _setMintPool("safelp_30");
        _setMintPool("safelp_90");
        _setMintPool("mdclp_30");
        _setMintPool("mdclp_90");
        _setMintPool("mdclp_360");
        return true;
    }

    function _setMintPool(string memory _type) internal {
        if (_mintPool[_type].time == 0 && _mintPool[_type].deposit > 0) {
            _mintPool[_type].time = _timedate;
        }

        if (_mintPool[_type].deposit > 0 && _mintPool[_type].time < _timedate) {
            uint256 _amount = _timedate
                .sub(_mintPool[_type].time)
                .div(12 hours)
                .mul(_miningPools[_type].output.div(2));
            _mintPool[_type].mintAmount += _amount;
            _mintPool[_type].time = _timedate;
        }

        if (_indexGlobal[_type].time < _timedate) {
            _indexGlobal[_type].amount = depositValueTotal(_type);
            _indexGlobal[_type].time = _timedate;
        }
    }

    function setDatetime() public {
        _setDatetime();
    }

    function setDatetime(uint256 _time) public {
        require(_time % 12 hours == 0);
        _timedate = _time;
    }

    function setSafeLP(address _lp) public onlyOwner {
        _safeLP = _lp;
    }

    function setMdcLP(address _lp) public onlyOwner {
        _mdcLP = _lp;
    }

    function setComposeRate(uint256 _rate) public onlyOwner {
        require(_rate > 0 && _rate < 100);
        _rateSafe = _rate;
    }

    function setMiningPool(
        string memory _type,
        uint256 _limit,
        uint256 _pledge,
        uint256 _output,
        uint256 _supply,
        uint256 _surplus,
        bool _enable
    ) public onlyOwner {
        _miningPools[_type] = MiningPool(
            _limit,
            _pledge,
            _output,
            _supply,
            _surplus,
            _enable
        );
    }

    function setMiningPool(string memory _type, bool _enable) public onlyOwner {
        _miningPools[_type].enable = _enable;
    }
}
