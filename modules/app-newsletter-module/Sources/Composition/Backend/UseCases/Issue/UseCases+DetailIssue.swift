import FeatherDatabase
import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeDetailIssue() -> Issue.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.Detail.Scope(
                    issue: Issue.Detail.Query.Database(context: context)
                )
            }
        )
        return Issue.Detail.UseCase(authorizer: authorizer, query: query)
    }
}
