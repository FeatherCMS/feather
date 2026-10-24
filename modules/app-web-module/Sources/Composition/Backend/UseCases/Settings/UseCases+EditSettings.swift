import FeatherInfrastructure
import WebApplication
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    func makeEditSettings() -> Settings.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Settings.Edit.Scope(
                    settings: Settings.Repository.Database(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
