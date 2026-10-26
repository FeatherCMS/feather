import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
public import NewsModule
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeRemoveCategory() -> Category.Remove.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Category.Remove.Scope(
                        article: Article.Repository.Database(context: context),
                        category: Category.Repository.Database(
                            context: context
                        ),
                        metadata: WebModule.Metadata.Repository.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
