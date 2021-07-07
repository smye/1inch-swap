from brownie import SwapProxy, accounts, config, network, interface, run
from scripts.swap import get_acc

def main():

    active_network = config['networks'][network.show_active()]

    acc = get_acc()

    swap_proxy = SwapProxy.deploy(
        active_network['router'],
        {'from': acc}
    )

    print(f'Deployed SwapProxy at {swap_proxy}')

    run('swap')
