import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {

    func makeAddPage() -> Page.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Page.Add.Scope(
                    page: Page.Repository.Database(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
