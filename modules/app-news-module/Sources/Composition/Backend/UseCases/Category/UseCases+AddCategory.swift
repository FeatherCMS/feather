import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
public import NewsModule
import SystemInfrastructure
import SystemModule
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeAddCategory() -> Category.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Category.Add.Scope(
                        category: Category.Repository.Database(
                            context: context
                        ),
                        metadata: WebModule.Metadata.Repository.Database(
                            context: context
                        ),
                        variable: SystemModule.Variable.Lookup.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
