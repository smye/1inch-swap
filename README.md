# 1inch ProxySwap

A minimal example showing how to integrate 1inch with your smart contract

![image](https://user-images.githubusercontent.com/17861005/124692865-452ee180-ded6-11eb-9cab-3edc36171b04.png)

## Dependencies
- [python3](https://www.python.org/)
- [ganache-cli](https://github.com/trufflesuite/ganache-cli)

## Installation

```bash
git clone https://github.com/smye/1inch-swap.git
cd 1inch-swap
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```


## Usage
- Add the `OpenZeppelin` dependencies via `Brownies` package manager
    ```bash
    brownie pm install OpenZeppelin/openzeppelin-contracts@4.1.0
    ```
    
- To add a `live` network to `Brownie`
    ```bash
    brownie networks add Ethereum polygon host=https://matic-mainnet.chainstacklabs.com  chainid=137 explorer=https://api.polygonscan.com/api
    ```

- For a `development` network 
    ```bash
    brownie networks add Development polygon-fork host=http://127.0.0.1 cmd=ganache-cli fork=https://matic-mainnet.chainstacklabs.com port=8545
    ```

- Modify `brownie-config.yaml`
    - router: Address of the 1inch router 
    - tokenIn: Input token address
    - tokenOut: Address of token to receive
    - amount: Amount of tokenIn being swapped
    - slippage: Percentage that amount of tokenOut can deviate from the quote by, before reverting
    - chain_id: Chain ID of the current network, used for querying 1inch API

- Set the `PRIVATE_KEY` environment variable (for live networks)
    ```bash
    export PRIVATE_KEY=0x....
    ```
   
- To deploy the `SwapProxy` contract on a `mainnet-fork`
    ```bash
    brownie run deploy_swap.py --network polygon-fork --interactive
    ```
    
- To execute a `swap` on an already deployed `SwapProxy` contract on a `mainnet-fork`
    ```bash
    brownie run swap.py --network polygon-fork --interactive
    ```

## Notes

- Deploying on `mainnet` is exactly the same, but replace `polygon-fork` with `polygon`

- By default the account used in a forked environment is defined in the `get_acc()` function in `swap.py`

- The slippage protection (`minOut`) isn't strictly required in the contract as it is provided in the `swap_req["tx"]["data"]` value returned by the 1inch API, however, it is an additional failsafe
