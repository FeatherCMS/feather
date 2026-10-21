import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeGetMagicLink() -> MagicLink.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                MagicLink.Detail.Scope(
                    magicLink: MagicLink.Detail.Query.Database(
                        context: context
                    )
                )
            }
        )
        return MagicLink.Detail.UseCase(authorizer: authorizer, query: query)
    }
}
