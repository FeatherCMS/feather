import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation

extension UseCases {

    public func makeUpdateContactFormSubmission() -> UpdateSubmission {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
}
