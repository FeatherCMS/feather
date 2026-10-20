import FeatherInfrastructure
import SystemApplication
import SystemDomain
import SystemInfrastructure
import SystemModule

extension UseCases {

    func makeEditVariable() -> SystemModule.Variable.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Variable.Edit.Scope(
                    variable: SystemModule.Variable.Repository.Database(
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
