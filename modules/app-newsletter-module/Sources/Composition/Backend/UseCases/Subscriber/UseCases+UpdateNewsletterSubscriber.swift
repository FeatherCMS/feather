import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsletterApplication
import NewsletterDomain
import NewsletterInfrastructure

extension UseCases {

    func makeUpdateNewsletterSubscriber() -> UpdateSubscriber {
        .init(
            authorizer: authorizer,
            transaction: transaction()
        )
    }
}
