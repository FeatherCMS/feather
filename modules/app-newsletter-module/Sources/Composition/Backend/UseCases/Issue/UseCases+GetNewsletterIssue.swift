import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsletterApplication
import NewsletterDomain
import NewsletterInfrastructure

extension UseCases {

    func makeGetNewsletterIssue() -> GetIssue {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
