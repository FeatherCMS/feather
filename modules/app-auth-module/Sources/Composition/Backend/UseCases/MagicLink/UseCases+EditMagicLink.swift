import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeEditMagicLink() -> AuthApplication.EditMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMagicLink(
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return AuthApplication.EditMagicLink(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
