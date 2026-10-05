import FeatherInfrastructure
import UserApplication
import UserInfrastructure

extension UseCases {

    func makeListIdentities() -> ListIdentities {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadIdentity(
                    identity: IdentityDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }
}
