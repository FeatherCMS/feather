import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation

extension UseCases {

    public func makeSubmitContactForm() -> SubmitForm {
        .init(
            transaction: formTransaction()
        )
    }
}
