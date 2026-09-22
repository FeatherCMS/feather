import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaApplication
import MediaDomain
import MediaInfrastructure

extension UseCases {

    public func makeCreateFolder() -> CreateMediaFolder {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction()
        )
    }
}
