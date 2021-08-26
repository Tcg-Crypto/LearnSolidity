from brownie import Contract, accounts

def main():
    dai = Contract.from_explorer("0x6B175474E89094C44Da98b954EedeAC495271d0F")
    contract = Contract.from_explorer("0x2a1530C4C41db0B0b2bB646CB5Eb1A67b7158667")
    print(contract.name())
    contract.ethToTokenSwapInput(
        1,  # minimum amount of tokens to purchase
        9999999999,  # timestamp
        {
            "from": accounts[0],
            "value": "1 ether"
        }
    )
    print("Balance of dai is")
    print(dai.balanceOf(accounts[0])/10**18)






