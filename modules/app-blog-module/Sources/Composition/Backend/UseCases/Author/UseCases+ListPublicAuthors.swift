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
                    authorList: Public.Author.List.Query.Database(
                        context: context
                    ),
                    authorDetail: Public.Author.Detail.Query.Database(
                        context: context,
                        metadata: WebModule.Metadata.Reference.Query.Database(
                            context: context
                        )
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
