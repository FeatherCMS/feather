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

    public func makeDeleteFolder() -> DeleteMediaFolder {
            .init(
                authorizer: authorizer,
                transaction: writeTransaction(),
                storage: storage()
            )
        }
}

