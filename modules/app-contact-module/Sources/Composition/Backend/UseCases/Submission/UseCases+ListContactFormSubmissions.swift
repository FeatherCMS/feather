public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {

    public func makeListContactFormSubmissions() -> ListSubmissions {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
}
