import FeatherInfrastructure
public import UserApplication
import UserInfrastructure

extension UseCases {

    public func makeGetIdentity() -> GetIdentity {
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
