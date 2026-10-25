import FeatherInfrastructure
import NewsInfrastructure
import WebInfrastructure
import WebModule
public import NewsApplication
public import NewsModule

extension UseCases {

    public func makeEditCategory() -> Category.Edit.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Category.Edit.Scope(
                        category: Category.Repository.Database(context: context),
                        metadata: WebModule.Metadata.Repository.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
