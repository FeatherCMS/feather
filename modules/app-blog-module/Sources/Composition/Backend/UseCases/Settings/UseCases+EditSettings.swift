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
import WebModule

extension UseCases {

    public func makeEditSettings() -> BlogModule.Settings.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                BlogModule.Settings.Edit.Scope(
                    settings: BlogModule.Settings.Repository.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
