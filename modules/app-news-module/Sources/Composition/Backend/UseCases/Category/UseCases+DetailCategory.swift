import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
public import NewsModule
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeDetailCategory() -> Category.Detail.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Category.Detail.Scope(
                        category: Category.Detail.Query.Database(
                            context: context,
                            metadata: WebModule.Metadata.Reference.Query
                                .Database(
                                    context: context
                                )
                        )
                    )
                }
            )
        )
    }
}
