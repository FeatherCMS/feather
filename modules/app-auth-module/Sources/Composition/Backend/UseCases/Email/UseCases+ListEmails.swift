import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherApplication
import FeatherInfrastructure

extension UseCases {
    func makeListEmails() -> Email.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext
        ) { context in
            Email.List.Scope(
                authEmail: Email.List.Query.Database(context: context)
            )
        }
        return .init(authorizer: authorizer, query: query)
    }
}
