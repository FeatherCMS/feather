import FeatherInfrastructure
import RedirectApplication
import RedirectInfrastructure
import RedirectModule

extension UseCases {

    func makeAddRule() -> Rule.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Rule.Add.Scope(
                    repository: Rule.Repository.Database(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
