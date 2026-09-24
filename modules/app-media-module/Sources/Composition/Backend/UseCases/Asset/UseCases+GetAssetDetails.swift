import FeatherInfrastructure
public import MediaApplication
import MediaInfrastructure

extension UseCases {

    public func makeGetAssetDetails() -> GetMediaAssetDetails {
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
