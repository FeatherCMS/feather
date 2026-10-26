import FeatherInfrastructure
import RedirectApplication
import RedirectInfrastructure
import RedirectModule

extension UseCases {

    func makeRemoveRule() -> Rule.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Rule.Remove.Scope(
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
