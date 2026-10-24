import FeatherApplication
import FeatherDomain
import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {

    public func makeEditAsset() -> Asset.File.Edit.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Asset.File.Edit.Scope(
                        assets: Asset.File.Repository.Database(context: context)
                    )
                }
            ),
            objectKeyGenerator: storageContext.objectKeyGenerator
        )
    }
}
