import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeListMagicLinks() -> ListMagicLinks {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
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
