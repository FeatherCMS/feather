import FeatherApplication
import FeatherDatabase
import FeatherInfrastructure
import FeatherModuleKit
import WebApplication
import WebDomain
import WebInfrastructure

extension UseCases {
    func makeSearchMetadata() -> Metadata.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Metadata.Search.Scope(
                    metadata: Metadata.Search.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }
}
