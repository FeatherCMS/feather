import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {
    func makeSearchCredentials() -> Credential.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Credential.Search.Scope(
                    query: Credential.Search.Query.Database(context: context)
                )
            }
        )
        return Credential.Search.UseCase(authorizer: authorizer, query: query)
    }
}
