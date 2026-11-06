import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {
    func makeSearchMagicLinks() -> MagicLink.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                MagicLink.Search.Scope(
                    query: MagicLink.Search.Query.Database(context: context)
                )
            }
        )
        return MagicLink.Search.UseCase(authorizer: authorizer, query: query)
    }
}
