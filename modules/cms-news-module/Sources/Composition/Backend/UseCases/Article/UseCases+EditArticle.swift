import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
public import NewsModule
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeEditArticle() -> Article.Edit.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Article.Edit.Scope(
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
