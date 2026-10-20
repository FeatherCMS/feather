import FeatherInfrastructure
import SystemApplication
import SystemDomain
import SystemInfrastructure
import SystemModule

extension UseCases {

    func makeRemovePermission() -> SystemModule.Permission.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Permission.Remove.Scope(
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
