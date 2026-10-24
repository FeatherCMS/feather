import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeAddMagicLink() -> MagicLink.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                MagicLink.Add.Scope(
                    magicLink: MagicLink.Repository.Database(context: context)
                )
            }
        )
        return MagicLink.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
