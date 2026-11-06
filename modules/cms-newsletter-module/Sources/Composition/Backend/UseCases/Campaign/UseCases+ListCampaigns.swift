import FeatherDatabase
import FeatherInfrastructure
import NewsletterApplication
import NewsletterInfrastructure
import NewsletterModule

extension UseCases {

    func makeListCampaigns() -> Campaign.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Campaign.List.Scope(
                    campaign: Campaign.List.Query.Database(context: context)
                )
            }
        )
        return Campaign.List.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
