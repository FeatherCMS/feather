import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeListMagicLinks() -> MagicLink.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                MagicLink.List.Scope(
                    magicLink: MagicLink.List.Query.Database(
                        context: context
                    )
                )
            }
        )
        return MagicLink.List.UseCase(authorizer: authorizer, query: query)
    }
}
