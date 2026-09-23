import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
public import MediaApplication
import MediaDomain
import MediaInfrastructure

extension UseCases {

    public func makeSearchAssets() -> SearchMediaAssets {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadMedia(
                    folders: MediaFolderDatabaseQueries(
                        context: context
                    ),
                    assets: MediaAssetDatabaseQueries(
                        context: context
                    ),
                    assetSearch: MediaAssetSearchDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
