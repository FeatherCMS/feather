import AuthAdminAPI
import AuthAppAPI
import AuthApplication
import AuthInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import UserApplication
import UserBackend
import UserInfrastructure

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

