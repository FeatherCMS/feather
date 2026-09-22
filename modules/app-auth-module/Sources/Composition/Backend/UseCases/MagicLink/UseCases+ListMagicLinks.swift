import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

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
