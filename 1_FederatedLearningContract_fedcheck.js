const FederatedLearningContract = artifacts.require("FederatedLearningContract");

module.exports = function (deployer) {
    const requiredUpdates = 2;
    deployer.deploy(FederatedLearningContract, requiredUpdates);
};
