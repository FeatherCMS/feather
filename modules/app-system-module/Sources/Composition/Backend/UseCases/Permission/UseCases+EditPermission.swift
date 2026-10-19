import SystemModule
import FeatherInfrastructure
import SystemApplication
import SystemDomain
import SystemInfrastructure

extension UseCases {

    func makeEditPermission() -> SystemModule.Permission.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Permission.Edit.Scope(
                    permission: SystemModule.Permission.Repository.Database(
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
