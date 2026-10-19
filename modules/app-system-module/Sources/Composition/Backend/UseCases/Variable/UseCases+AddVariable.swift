import SystemModule
import FeatherInfrastructure
import SystemApplication
import SystemDomain
import SystemInfrastructure

extension UseCases {

    func makeAddVariable() -> SystemModule.Variable.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Variable.Add.Scope(
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
