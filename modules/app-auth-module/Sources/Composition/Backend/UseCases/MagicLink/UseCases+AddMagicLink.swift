import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeAddMagicLink() -> AddMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMagicLink(
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return AddMagicLink(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
