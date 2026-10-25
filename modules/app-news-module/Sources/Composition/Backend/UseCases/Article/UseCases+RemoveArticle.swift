import FeatherInfrastructure
import NewsInfrastructure
import WebInfrastructure
import WebModule
public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeRemoveArticle() -> Article.Remove.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Article.Remove.Scope(
                        article: Article.Repository.Database(context: context),
                        metadata: WebModule.Metadata.Repository.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
