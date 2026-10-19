public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {

    public func makeListFormFields() -> ListFormFields {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
}
