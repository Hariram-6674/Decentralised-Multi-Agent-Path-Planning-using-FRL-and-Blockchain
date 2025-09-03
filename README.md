# Decentralised-Multi-Agent-Path-Planning-using-FRL-and-Blockchain

### Files Description

- **1_FederatedLearningContract_fedcheck.js**  
  Deployment script used to deploy the smart contract (`FedCheck.sol`) to a local Ethereum test network (e.g., Ganache).

- **Codes.ipynb**  
  Jupyter notebook containing the main Multi Agent Federated Learning simulation code using PPO and Blockchain. Includes training with and without FL of Agents running PPO, Static and Dynamic obstacles simulation, and FL integrated with Blockchain.

- **FedCheck.sol**  
  Solidity smart contract that defines the blockchain-based verification logic. It ensures only verified agents can participate in global model updates.

- **FederatedLearningContract.json**  
  Compiled contract artifact (ABI and bytecode) required for interacting with the deployed contract from Python.

- **Blockchain_round_outputs**  
  Contains blockchain-related results, logs, and verification outputs generated during simulations.

- **FL_output**  
  Stores results of federated learning comparison experiments, including plots, metrics, and outputs from simulation notebooks in Simulation.ipynb.
