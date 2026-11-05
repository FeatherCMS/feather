import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeDetailCredential() -> Credential.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Credential.Detail.Scope(
                    credential: Credential.Detail.Query.Database(
                        context: context
                    )
                )
            }
        )
        return Credential.Detail.UseCase(authorizer: authorizer, query: query)
    }
}
