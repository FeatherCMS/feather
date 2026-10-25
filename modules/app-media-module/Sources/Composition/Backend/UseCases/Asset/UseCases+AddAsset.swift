import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {

    public func makeAddAsset() -> Asset.File.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Asset.File.Add.Scope(
                        folders: Asset.Folder.Repository.Database(
                            context: context
                        ),
                        assets: Asset.File.Repository.Database(
                            context: context
                        ),
                        storageObjects: StorageObject.Repository.Database(
                            context: context
                        ),
                        variantProcessors: Variant.Processor.Repository.Database(
                            context: context
                        )
                    )
                }
            ),
            storageContext: storageContext,
            jobs: jobs
        )
    }
}
