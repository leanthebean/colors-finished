const tokenContract = artifacts.require('./ColorsERC721.sol')
const BigNumber = web3.BigNumber
  
contract('ColorsERC721', accounts => {
  var owner = accounts[0]  
  let colors

  beforeEach(async function () {
    colors = await tokenContract.new({ from: owner })
  })

  it('initial state', async function () { 
    const name = await colors.name()
    const symbol = await colors.symbol()

    assert.equal(name, "COLORS")
    assert.equal(symbol, "HEX")
  })

  it('has correct owner', async function () { 
    const actualOwner = await colors.owner()
    assert.equal(actualOwner, owner)
  })

  describe('can mint colors', () => { 
    let colorId = 16711680;
    let tx; 
    let price = new web3.BigNumber(10000000000000000)
    
    beforeEach(async function () { 
      tx = await colors.mint(colorId, { from:owner, value:price }) 
    })

    it('can mint us a color', async function () { 
      assert(colors.ownerOf(colorId), owner)
      assert.equal(tx.logs[0].event, 'Transfer')
    })

    it('can retrieve tokens for the owner', async function () { 
      let tokens = await colors.tokensOf(owner)

      assert.equal(tokens.length, 1)
      assert.equal(tokens[0, new web3.BigNumber(colorId)])
    })

    it('cant mint tokens that have been minted before', async function () { 
      await expectThrow(colors.mint(colorId, {from:owner}))
    })
  })

  var expectThrow = async promise => {
    try {
      await promise;
    } catch (error) {
      // TODO: Check jump destination to destinguish between a throw
      //       and an actual invalid jump.
      const invalidOpcode = error.message.search('invalid opcode') >= 0;
      // TODO: When we contract A calls contract B, and B throws, instead
      //       of an 'invalid jump', we get an 'out of gas' error. How do
      //       we distinguish this from an actual out of gas event? (The
      //       testrpc log actually show an 'invalid jump' event.)
      const outOfGas = error.message.search('out of gas') >= 0;
      const revert = error.message.search('revert') >= 0;
      assert(
        invalidOpcode || outOfGas || revert,
        'Expected throw, got \'' + error + '\' instead',
      );
      return;
    }
    assert.fail('Expected throw not received');
  };
})