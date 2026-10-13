import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeRemoveMagicLink() -> RemoveMagicLink {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteMagicLink(
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return RemoveMagicLink(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
