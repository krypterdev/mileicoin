// TIME-LOCK by Krypter Developments
// THANKS TO: Zeppelin

pragma solidity ^0.5.7;


import './MileiICO.sol';

/**
 * @title TokenTimelock
 * @dev TokenTimelock is a token holder contract that will allow a
 * beneficiary to extract the tokens after a given release time
 */
contract TokenTimelock {

  // ERC20 basic token contract being held
  IERC20 public token;

  // beneficiary of tokens after they are released
  address public beneficiary;

  // timestamp when token release is enabled
  uint64 public releaseTime;

  address public owner;

  bool setted;

  constructor(IERC20 _token, uint64 _releaseTime) public {
    require(_releaseTime > now);
    token = _token;
    beneficiary = address(0);
    releaseTime = _releaseTime;
    setted = false;
    owner = msg.sender;
  }

  function setBeneficiary(address _beneficiary) public {
      require(msg.sender == owner);
      require(setted == false);
      beneficiary = _beneficiary;
      setted = true;
  }

  function getSetted() public view returns(bool){
      return setted;
  }

  function getReleaseTime() public view returns(uint64){
      return releaseTime;
  }

  function getBeneficiary() public view returns(address) {
      return beneficiary;
  }

  /**
   * @notice Transfers tokens held by timelock to beneficiary.
   */
  function release() public {
    require(now >= releaseTime);

    uint256 amount = token.balanceOf(address(this));
    require(amount > 0);

    token.transfer(beneficiary, amount);
  }
}