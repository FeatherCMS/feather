import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherApplication
import FeatherInfrastructure

extension UseCases {
    func makeDetailEmail() -> Email.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext
        ) { context in
            Email.Detail.Scope(
                email: Email.Detail.Query.Database(context: context)
            )
        }
        return .init(authorizer: authorizer, query: query)
    }
}
