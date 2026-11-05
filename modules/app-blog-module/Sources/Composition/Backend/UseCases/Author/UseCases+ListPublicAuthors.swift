public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeListPublicAuthors()
        -> BlogApplication.Public.Author.List.UseCase
    {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                BlogApplication.Public.Author.List.Scope(
                    authorList: BlogApplication.Public.Author.List.Query
                        .Database(
                            context: context
                        ),
                    metadata: WebModule.Metadata.Reference.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
