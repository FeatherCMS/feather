import FeatherInfrastructure
public import UserApplication
import UserInfrastructure
public import UserModule

extension UseCases {

    public func makeGetIdentity() -> Identity.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Identity.Query.Scope(
                    identity: Identity.Query.Database(
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
