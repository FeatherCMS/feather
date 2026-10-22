public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeAddAuthor() -> Author.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Author.Add.Scope(
                    author: Author.Repository.Database(
                        context: context
                    ),
                    metadata: Metadata.Repository.Database(
                        context: context
                    ),
                    variable: SystemModule.Variable.Lookup.Database(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
