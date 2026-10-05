import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeGetMagicLink() -> GetMagicLink {
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
        return GetMagicLink(authorizer: authorizer, query: query)
    }
}
