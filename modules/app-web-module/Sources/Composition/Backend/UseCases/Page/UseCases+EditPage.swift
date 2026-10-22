import FeatherInfrastructure
import WebApplication
import WebDomain
import WebInfrastructure

extension UseCases {

    func makeEditPage() -> Page.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Page.Edit.Scope(
                    page: Page.Repository.Database(context: context),
                    metadata: Metadata.Repository.Database(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
