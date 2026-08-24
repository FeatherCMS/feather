import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherStorageFS
import Foundation
import MediaApplication
import MediaDomain
import MediaInfrastructure

extension UseCases {

    public func makeListFolders() -> ListMediaFolders {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadMedia(
                    folders: MediaFolderDatabaseQueries(
                        context: context
                    ),
                    assets: MediaAssetDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
