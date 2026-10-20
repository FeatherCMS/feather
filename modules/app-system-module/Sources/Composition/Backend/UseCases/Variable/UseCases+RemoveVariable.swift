import FeatherInfrastructure
import SystemApplication
import SystemDomain
import SystemInfrastructure
import SystemModule

extension UseCases {

    func makeRemoveVariable() -> SystemModule.Variable.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Variable.Remove.Scope(
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
