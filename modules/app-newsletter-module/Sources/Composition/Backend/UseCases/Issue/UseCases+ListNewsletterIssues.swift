import FeatherDatabase
import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeListNewsletterIssues() -> Issue.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Issue.List.Scope(
                    issue: Issue.List.Query.Database(context: context)
                )
            }
        )
        return Issue.List.UseCase(authorizer: authorizer, query: query)
    }
}
