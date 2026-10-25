import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
public import NewsModule

extension UseCases {
    public func makeSearchCategories() -> Category.Search.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Category.Search.Scope(
                        category: Category.Search.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
