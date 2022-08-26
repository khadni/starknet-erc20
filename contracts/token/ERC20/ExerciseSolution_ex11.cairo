%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address

from contracts.token.ERC20.IDTKERC20 import IDTKERC20

from openzeppelin.security.safemath.library import SafeUint256


#
# Storage
#


# Define a storage variable
@storage_var
func balance() -> (res : felt):
end


# Keeps list of holders 
@storage_var
func holders_list(account : felt) -> (amount : Uint256):
end



#
# Getters
#


# Returns the current balance.
@view
func get_balance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res : felt):
    let (res) = balance.read()
    return (res)
end


# Returns the current custody balance per holder
@view
func tokens_in_custody{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(account : felt) -> (amount : Uint256):
    let (res : Uint256) = holders_list.read(account)
    return (amount = res)
end



#
# Externals
#


# Increases the balance by the given amount
@external
func increase_balance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        amount : felt):
    let (res) = balance.read()
    balance.write(res + amount)
    return ()
end


# Get tokens from Dummy ERC20 contract
@external
func get_tokens_from_contract{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (amount : Uint256):

    let (caller_address) = get_caller_address()

    let (faucet_call_result) = IDTKERC20.faucet(0x066aa72ce2916bbfc654fd18f9c9aaed29a4a678274639a010468a948a5e2a96)

    let (res : Uint256) = holders_list.read(caller_address)

    let (new_amount: Uint256) = SafeUint256.add(res, Uint256(100*1000000000000000000, 0))

    # Store new value in custody for holder
    holders_list.write(account=caller_address, value=new_amount)

    # returns added amount
    return (amount = Uint256(100*1000000000000000000, 0))
end