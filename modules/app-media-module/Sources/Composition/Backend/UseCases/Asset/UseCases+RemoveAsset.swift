import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation
import MediaApplication
import MediaDomain
import MediaInfrastructure

extension UseCases {

    public func makeRemoveAsset() -> RemoveMediaAsset {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(),
            storage: storage,
            storageKeyShard: storageKeyShard
        )
    }
}
