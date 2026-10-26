import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
public import NewsModule

extension UseCases {

    public func makeListCategories() -> Category.List.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Category.List.Scope(
                        category: Category.List.Query.Database(context: context)
                    )
                }
            )
        )
    }
}
