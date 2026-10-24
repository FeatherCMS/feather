import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
public import MediaApplication
import MediaDomain
import MediaInfrastructure
public import MediaModule

extension UseCases {

    public func makeAddFolder() -> Asset.Folder.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: writeTransaction(scope: { context in
                Asset.Folder.Add.Scope(
                    folders: Asset.Folder.Repository.Database(context: context)
                )
            })
        )
    }
}
