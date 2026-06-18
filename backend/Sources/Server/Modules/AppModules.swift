import Application
import Infrastructure
import AuthApplication
import AuthInfrastructure
import UserApplication
import UserInfrastructure
import MediaApplication
import MediaInfrastructure
import AnalyticsApplication
import AnalyticsInfrastructure
import WebApplication
import WebInfrastructure
import RedirectApplication
import RedirectInfrastructure
import BlogApplication
import BlogInfrastructure

struct AppModules: Sendable {

    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    let system: SystemModule
    let analytics: AnalyticsModule
    let redirect: RedirectModule
    let web: WebModule
    let blog: BlogModule
    let user: UserModule
    let auth: AuthModule
    let media: MediaModule

    init(
        infrastructure: AppInfrastructure
    ) {
        self.infrastructure = infrastructure

        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                AuthScope(
                    account: DatabaseAccountQueries(
                        connection: connection
                    ),
                    rolePermissions: DatabaseRolePermissionQueries(
                        connection: connection
                    )
                )
            }
        )
        self.authorizer = DefaultAuthorizer(query: query)

        self.system = .init(
            infrastructure: infrastructure,
            authorizer: authorizer
        )
        self.analytics = .init(
            infrastructure: infrastructure,
            authorizer: authorizer
        )
        self.redirect = .init(
            infrastructure: infrastructure,
            authorizer: authorizer
        )
        self.web = .init(
            infrastructure: infrastructure,
            authorizer: authorizer
        )
        self.blog = .init(
            infrastructure: infrastructure,
            authorizer: authorizer
        )
        self.user = .init(
            infrastructure: infrastructure,
            authorizer: authorizer
        )
        self.auth = .init(
            infrastructure: infrastructure,
            authorizer: authorizer
        )
        self.media = .init(
            infrastructure: infrastructure,
            authorizer: authorizer
        )
    }
}
