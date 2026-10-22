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

    func makeListCredential() -> Credential.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Credential.List.Scope(
                    credential: Credential.List.Query.Database(
                        context: context
                    )
                )
            }
        )
        return Credential.List.UseCase(authorizer: authorizer, query: query)
    }
}
