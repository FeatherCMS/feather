public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeListPublicAuthors() -> Public.Author.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Public.Author.List.Scope(
                    author: Public.Author.Database(
                        context: context,
                        metadata: WebModule.Metadata.Query.Database(
                            context: context
                        )
                    ),
                    authorList: Public.Author.Database(
                        context: context,
                        metadata: WebModule.Metadata.Query.Database(
                            context: context
                        )
                    ),
                    metadata: WebModule.Metadata.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
