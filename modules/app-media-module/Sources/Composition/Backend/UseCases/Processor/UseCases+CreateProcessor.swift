import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherStorageFS
import Foundation
import MediaApplication
import MediaDomain
import MediaInfrastructure

extension UseCases {

    public func makeCreateProcessor() -> CreateMediaProcessor {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction()
        )
    }
}
