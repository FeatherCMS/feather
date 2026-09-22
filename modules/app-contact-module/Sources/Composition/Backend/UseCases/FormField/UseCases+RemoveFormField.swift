import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {

    public func makeRemoveFormField() -> RemoveFormField {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
}
