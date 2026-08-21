import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation

extension UseCases {

    public func makeDeleteContactForm() -> DeleteForm {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
}
