import FeatherInfrastructure
public import UserApplication
import UserInfrastructure
public import UserModule

extension UseCases {
    public func makeDetailIdentity() -> Identity.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Identity.Detail.Scope(
                    identity: Identity.Detail.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
