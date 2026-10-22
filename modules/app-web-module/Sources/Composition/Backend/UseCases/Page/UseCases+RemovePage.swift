import FeatherInfrastructure
import WebApplication
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    func makeRemovePage() -> Page.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Page.Remove.Scope(
                    page: Page.Repository.Database(context: context),
                    metadata: Metadata.Repository.Database(context: context),
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
