import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import MediaApplication
import MediaDomain
import MediaInfrastructure

extension UseCases {

    public func makeEditFolder() -> EditMediaFolder {
        .init(authorizer: authorizer, transaction: writeTransaction())
    }
}
