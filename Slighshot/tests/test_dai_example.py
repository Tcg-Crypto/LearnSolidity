import pytest
from brownie import Contract


@pytest.fixture
def dai():
    yield Contract.from_explorer("0x6B175474E89094C44Da98b954EedeAC495271d0F")

    
def test_dai_fixture(dai):
    assert dai.name() == "Dai Stablecoin"