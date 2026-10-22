public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
import MediaBackend
import SystemInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeEditSettings() -> Settings.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Settings.Edit.Scope(
                    settings: Settings.Repository.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
