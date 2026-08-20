import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemAdminAPI
import SystemAppAPI
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeEditVariable() -> EditVariable {
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    WriteVariable(
                        variable: VariableDatabaseRepository(context: context)
                    )
                }
            )
            return .init(
                authorizer: authorizer,
                transaction: transaction
            )
        }
}

