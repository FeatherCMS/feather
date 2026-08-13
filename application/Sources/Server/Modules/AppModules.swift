import FeatherContracts
import FeatherApplication
import FeatherInfrastructure
import AuthApplication
import AuthInfrastructure
import UserApplication
import UserInfrastructure
import MediaBackend
import AnalyticsBackend
import WebApplication
import WebInfrastructure
import WebBackend
import NewsletterBackend
import RedirectBackend
import BlogBackend
import ContactBackend
import NewsletterApplication
import NewsletterInfrastructure
import AccountApplication
import AccountInfrastructure
import AccountBackend
import SystemBackend
import UserBackend
import AuthBackend
import NewsBackend

struct AppModules: Sendable {

    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    let system: SystemBackend
    let analytics: AnalyticsBackend
    let redirect: RedirectBackend
    let web: WebBackend
    let blog: BlogBackend
    let news: NewsBackend
    let user: UserBackend
    let auth: AuthBackend
    let media: MediaBackend
    let contact: ContactBackend
    let newsletter: NewsletterBackend
    let account: AccountModule
    let accountBackend: AccountBackend

    init(
        infrastructure: AppInfrastructure
    ) {
        self.infrastructure = infrastructure

        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                return AuthScope(
                    identity: IdentityDatabaseQueries(
                        context: context
                    ),
                    rolePermissions: RolePermissionDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        self.authorizer = DefaultAuthorizer(query: query)

        self.system = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.analytics = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.redirect = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.news = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.user = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            events: infrastructure.events
        )
        self.accountBackend = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            mailSender: JobQueueMailSender(queue: infrastructure.jobQueue),
            events: infrastructure.events
        )
        self.auth = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            user: self.user
        )
        self.media = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            mediaStorageRootPath: infrastructure.mediaStorageRootPath,
            authorizer: authorizer,
            variantQueue: JobMediaVariantQueue(queue: infrastructure.jobQueue)
        )
        let account = AccountModule(
            infrastructure: infrastructure,
            authorizer: authorizer
        )
        self.account = account

        self.blog = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            media: self.media
        )
        self.web = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.contact = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            mailQueue: JobContactMailQueue(queue: infrastructure.jobQueue)
        )
        self.newsletter = .init(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            mailQueue: JobNewsletterMailQueue(queue: infrastructure.jobQueue)
        )
    }
}
