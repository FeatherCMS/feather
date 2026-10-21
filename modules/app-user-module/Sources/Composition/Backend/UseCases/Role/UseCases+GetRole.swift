import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {

    func makeGetRole() -> Role.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Role.Detail.Scope(
                    role: Role.Detail.Query.Database(
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
