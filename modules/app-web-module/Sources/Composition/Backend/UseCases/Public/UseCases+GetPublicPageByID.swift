import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebInfrastructure

extension UseCases {

    func makeGetPublicPageByID() -> GetPublicPageByID {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadPageMetadata(
                    page: PageDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
