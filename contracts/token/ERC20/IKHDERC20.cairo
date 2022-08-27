%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IKHDERC20:
    # Mint function
    func mint(to: felt, amount: Uint256) -> ():
    end
    func burn(account: felt, amount: Uint256) -> ():
    end
    func transferFrom(sender: felt, recipient: felt, amount: Uint256) -> (success: felt):
    end
end