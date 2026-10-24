import FeatherApplication
import FeatherDomain
import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {

    public func makeDetailAsset() -> Asset.File.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Asset.File.Detail.Scope(
                    query: Asset.File.Detail.Query.Database(
                        context: context,
                        objectKeyGenerator: storageContext.objectKeyGenerator
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
