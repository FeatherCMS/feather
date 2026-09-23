public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {

    public func makeRemoveContactFormSubmission() -> RemoveSubmission {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
}
