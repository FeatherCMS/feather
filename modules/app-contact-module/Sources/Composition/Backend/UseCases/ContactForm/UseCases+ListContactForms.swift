public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {

    public func makeListContactForms() -> ListForms {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
}
