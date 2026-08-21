import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsletterApplication
import NewsletterDomain
import NewsletterInfrastructure

extension UseCases {

    func makeGetNewsletterSubscriber() -> GetSubscriber {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
