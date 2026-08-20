import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import RedirectAdminAPI
import RedirectAppAPI
import RedirectApplication
import RedirectInfrastructure

extension UseCases {

    func makeRemoveRule() -> RemoveRule {
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
                scope: { context in
                    WriteRule(
                        rule: RuleDatabaseRepository(context: context)
                    )
                }
            )
            return .init(
                authorizer: authorizer,
                transaction: transaction
            )
        }
}

