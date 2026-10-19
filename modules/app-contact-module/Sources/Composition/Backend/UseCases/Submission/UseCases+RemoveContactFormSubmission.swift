public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
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
