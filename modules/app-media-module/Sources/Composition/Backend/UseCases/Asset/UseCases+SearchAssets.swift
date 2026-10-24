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

    public func makeSearchAssets() -> Asset.File.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Asset.File.Search.Scope(
                    query: Asset.File.Search.Query.Database(
                        context: context,
                        objectKeyGenerator: storageContext.objectKeyGenerator
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
