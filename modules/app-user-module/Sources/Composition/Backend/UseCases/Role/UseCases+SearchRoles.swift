import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {

    func makeSearchRoles() -> Role.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Role.Search.Scope(
                    role: Role.Search.Database(
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
