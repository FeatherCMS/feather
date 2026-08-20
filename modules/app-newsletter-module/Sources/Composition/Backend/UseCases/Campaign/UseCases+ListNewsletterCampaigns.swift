import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsletterApplication
import NewsletterDomain
import NewsletterInfrastructure

extension UseCases {

    func makeListNewsletterCampaigns() -> ListCampaigns {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
