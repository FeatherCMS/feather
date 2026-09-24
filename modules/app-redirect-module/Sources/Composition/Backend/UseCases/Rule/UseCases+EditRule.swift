import FeatherInfrastructure
import RedirectApplication
import RedirectInfrastructure

extension UseCases {

    func makeEditRule() -> EditRule {
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
