import FeatherApplication
import FeatherDomain
import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure
public import MediaModule

extension UseCases {
    public func makePublicResolveMediaAssets()
        -> Asset.File.PublicResolve.UseCase
    {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Asset.File.PublicResolve.Scope(
                    query: Asset.File.PublicResolve.Query.Database(
                        context: context,
                        objectKeyGenerator: storageContext.objectKeyGenerator
                    )
                )
            }
        )
        return .init(query: query)
    }
}
