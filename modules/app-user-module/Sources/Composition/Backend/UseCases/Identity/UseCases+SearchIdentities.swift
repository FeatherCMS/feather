import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {

    func makeSearchIdentities() -> Identity.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Identity.Search.Scope(
                    identity: Identity.Search.Database(
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
