from brownie import accounts, config, tokenERC20, silvertkn, tokenSwap

initial_supply = 10000000000
token_name = "SGold"
token_symbol = "SGLD"

def main():
    account = accounts[0]
    tkn1 = tokenERC20.deploy(
        initial_supply, {"from":account[0]}
    )
    tkn2 = silvertkn.deploy(
        initial_supply, {"from":account[0]}
    )
    swapper = tokenSwap.deploy(tkn1.address,accounts[0],tkn2.address,accounts[1],{'from':accounts[2]})
    tkn1.approve(swapper.address,1e21,{'from': accounts[0]})
    tkn2.approve(swapper.address,1e21,{'from': accounts[1]})
    tx = swapper.swap(10000,10000,{'from':accounts[0]})
    tx.traceback()

    