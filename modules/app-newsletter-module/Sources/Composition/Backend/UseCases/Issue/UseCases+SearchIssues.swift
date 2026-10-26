import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {
    func makeSearchIssues() -> Issue.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Search.Scope(
                    issue: Issue.Search.Query.Database(context: context)
                )
            }
        )
        return Issue.Search.UseCase(authorizer: authorizer, query: query)
    }
}
