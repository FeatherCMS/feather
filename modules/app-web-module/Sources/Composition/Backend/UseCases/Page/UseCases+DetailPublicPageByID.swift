import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    func makeDetailPublicPageByID() -> WebApplication.Public.Page.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WebApplication.Public.Page.Detail.Scope(
                    page: Page.Detail.Query.Database(
                        context: context,
                        metadata: Metadata.Reference.Query.Database(
                            context: context
                        )
                    )
                )
            }
        )
        return .init(query: query)
    }
}
