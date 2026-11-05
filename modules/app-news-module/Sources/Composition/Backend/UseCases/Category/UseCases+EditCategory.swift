import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
public import NewsModule
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeEditCategory() -> Category.Edit.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Category.Edit.Scope(
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
