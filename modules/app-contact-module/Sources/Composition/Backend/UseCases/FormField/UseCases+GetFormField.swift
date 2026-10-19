public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {

    public func makeGetFormField() -> GetFormField {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
}
