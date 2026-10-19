public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {

    public func makeUpdateContactForm() -> UpdateForm {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
}
