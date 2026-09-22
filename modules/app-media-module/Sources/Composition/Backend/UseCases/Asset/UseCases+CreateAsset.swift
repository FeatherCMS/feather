import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaApplication
import MediaDomain
import MediaInfrastructure

extension UseCases {

    public func makeCreateAsset() -> CreateMediaAsset {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            storage: storage,
            storageKeyShard: storageKeyShard
        )
    }
}
