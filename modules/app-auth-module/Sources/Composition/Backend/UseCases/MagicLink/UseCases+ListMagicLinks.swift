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

    func makeListMagicLinks() -> ListMagicLinks {
            let query = DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadMagicLink(
                        magicLink: MagicLinkDatabaseQueries(
                            context: context
                        )
                    )
                }
            )
            return ListMagicLinks(authorizer: authorizer, query: query)
        }
}

