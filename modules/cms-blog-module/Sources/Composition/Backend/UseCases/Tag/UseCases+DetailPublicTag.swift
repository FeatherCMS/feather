public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeDetailPublicTag()
        -> BlogApplication.Public.Tag.Detail.UseCase
    {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                BlogApplication.Public.Tag.Detail.Scope(
                    tag: BlogApplication.Public.Tag.Detail.Query.Database(
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
