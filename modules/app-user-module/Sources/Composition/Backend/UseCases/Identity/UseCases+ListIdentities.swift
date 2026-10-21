import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {
    func makeListIdentities() -> Identity.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Identity.List.Scope(
                    identity: Identity.List.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
