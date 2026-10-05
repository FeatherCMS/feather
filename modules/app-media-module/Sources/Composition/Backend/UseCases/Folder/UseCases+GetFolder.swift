import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import MediaApplication
import MediaDomain
import MediaInfrastructure

extension UseCases {

    public func makeGetFolder() -> GetMediaFolder {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadMedia(
                    folders: MediaFolderDatabaseQueries(
                        context: context
                    ),
                    assets: MediaAssetDatabaseQueries(
                        context: context,
                        objectKeyGenerator: storageContext.objectKeyGenerator
                    ),
                    assetSearch: MediaAssetSearchDatabaseQueries(
                        context: context,
                        objectKeyGenerator: storageContext.objectKeyGenerator
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
