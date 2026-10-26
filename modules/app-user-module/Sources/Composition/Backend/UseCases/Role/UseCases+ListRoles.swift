import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {
    func makeListRoles() -> Role.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Role.List.Scope(
                    role: Role.List.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
