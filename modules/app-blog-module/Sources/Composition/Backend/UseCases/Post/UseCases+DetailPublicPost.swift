public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeDetailPublicPost()
        -> BlogApplication.Public.Post.Detail.UseCase
    {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                BlogApplication.Public.Post.Detail.Scope(
                    post: BlogApplication.Public.Post.Detail.Query.Database(
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
