import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {

    public func makeRemoveAsset() -> Asset.File.Remove.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Asset.File.Remove.Scope(
                        folders: Asset.Folder.Repository.Database(
                            context: context
                        ),
                        assets: Asset.File.Repository.Database(
                            context: context
                        ),
                        storageObjects: StorageObject.Repository.Database(
                            context: context
                        )
                    )
                }
            ),
            storageContext: storageContext
        )
    }
}
