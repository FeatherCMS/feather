import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeGetCredential() -> GetCredential {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadCredentialLink(
                    credential: CredentialDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return GetCredential(authorizer: authorizer, query: query)
    }
}
