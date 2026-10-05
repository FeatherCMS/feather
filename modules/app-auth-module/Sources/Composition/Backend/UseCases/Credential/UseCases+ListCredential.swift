import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeListCredential() -> ListCredential {
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
        return ListCredential(authorizer: authorizer, query: query)
    }
}
