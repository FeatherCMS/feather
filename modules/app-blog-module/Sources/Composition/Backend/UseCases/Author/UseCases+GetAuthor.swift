public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeGetAuthor() -> Author.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Author.Detail.Scope(
                    author: Author.Detail.Query.Database(
                        context: context,
                        metadata: Metadata.Query.Database(
                            context: context
                        )
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
