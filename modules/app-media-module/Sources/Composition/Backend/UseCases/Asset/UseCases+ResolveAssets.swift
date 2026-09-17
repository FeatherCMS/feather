import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation
import MediaApplication
import MediaDomain
import MediaInfrastructure

extension UseCases {
    public func makeResolveAssets() -> ResolveMediaAssets {
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

    public func makePublicResolveMediaAssets()
        -> PublicResolveMediaAssets
    {
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
        return .init(query: query)
    }
}
