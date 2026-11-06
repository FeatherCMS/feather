public import BlogApplication
import BlogInfrastructure
import BlogModule
import FeatherInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeDetailPublicAuthor()
        -> BlogApplication.Public.Author.Detail.UseCase
    {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                BlogApplication.Public.Author.Detail.Scope(
                    author: BlogApplication.Public.Author.Detail.Query.Database(
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
