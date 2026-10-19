public import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {

    public func makeSubmitContactForm() -> SubmitForm {
        .init(
            transaction: formTransaction(),
            jobs: jobs,
            events: events
        )
    }
}
