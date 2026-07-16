import AccountApplication
import AccountInfrastructure
import Application
import Infrastructure

struct AccountModule: Sendable {

    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    init(
        infrastructure: AppInfrastructure,
        authorizer: any Authorizer
    ) {
        self.infrastructure = infrastructure
        self.authorizer = authorizer
    }
}
