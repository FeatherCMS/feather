import AccountApplication
import AccountModule
public import FeatherApplication
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure
public import FeatherModuleKit

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let jobs: any SendMailJobController
    let events: any EventPublisher
    let credentialWriter: any Invitation.CompleteRegistration.CredentialWriter

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        jobs: any SendMailJobController,
        events: any EventPublisher
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.jobs = jobs
        self.events = events
        self.credentialWriter =
            Invitation.CompleteRegistration.CredentialWriterAdapter()
    }

}
