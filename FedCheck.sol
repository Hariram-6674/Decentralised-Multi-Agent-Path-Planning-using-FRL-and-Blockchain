// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract FederatedLearningContract {
    address public owner;

    mapping(address => bool) public authorizedClients;
    mapping(address => bool) public hasUpdated;
    mapping(address => uint256) public clientRewards;
    mapping(address => bytes32) public clientModelHashes;
    mapping(uint256 => bytes32) public globalModelHashes;

    uint256 public currentRound = 0;
    bool public aggregationComplete = false;
    uint256 public totalClientsUpdated = 0;
    uint256 public requiredUpdates;

    address[] public clientAddresses;

    event ClientRegistered(address clientAddress);
    event ClientUpdated(
        address clientAddress,
        bytes32 modelHash,
        uint256 reward,
        uint256 round
    );
    event GlobalModelUpdated(bytes32 modelHash, uint256 round);
    event RoundCompleted(uint256 round, uint256 participatingClients);
    event NewRoundStarted(uint256 round);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyAuthorizedClient() {
        require(
            authorizedClients[msg.sender],
            "Only registered clients can send updates"
        );
        _;
    }

    constructor(uint256 _requiredUpdates) {
        owner = msg.sender;
        requiredUpdates = _requiredUpdates;
    }

    function registerClient(address clientAddress) external onlyOwner {
        require(
            !authorizedClients[clientAddress],
            "Client already registered."
        );
        authorizedClients[clientAddress] = true;
        clientAddresses.push(clientAddress);
        emit ClientRegistered(clientAddress);
    }

    function submitUpdate(
        bytes32 modelHash,
        uint256 reward
    ) external onlyAuthorizedClient {
        require(
            !aggregationComplete,
            "Current round is complete, wait for new round"
        );
        require(
            !hasUpdated[msg.sender],
            "Client has already updated in this round"
        );

        // Client identity verified at this stage
        hasUpdated[msg.sender] = true;
        clientModelHashes[msg.sender] = modelHash;
        clientRewards[msg.sender] = reward;
        totalClientsUpdated++;

        emit ClientUpdated(msg.sender, modelHash, reward, currentRound);

        if (totalClientsUpdated >= requiredUpdates) {
            aggregationComplete = true;
            emit RoundCompleted(currentRound, totalClientsUpdated);
        }
    }

    function submitGlobalModel(bytes32 modelHash) external onlyOwner {
        require(
            aggregationComplete,
            "Cannot submit global model before all required clients update"
        );

        globalModelHashes[currentRound] = modelHash;
        emit GlobalModelUpdated(modelHash, currentRound);
    }

    function startNewRound() external onlyOwner {
        require(
            aggregationComplete,
            "Cannot start new round before completing current round"
        );

        currentRound++;
        aggregationComplete = false;
        totalClientsUpdated = 0;

        for (uint i = 0; i < clientAddresses.length; i++) {
            hasUpdated[clientAddresses[i]] = false;
        }

        emit NewRoundStarted(currentRound);
    }

    function getClientCount() external view returns (uint256) {
        return clientAddresses.length;
    }

    function setRequiredUpdates(uint256 _requiredUpdates) external onlyOwner {
        requiredUpdates = _requiredUpdates;
    }
}
