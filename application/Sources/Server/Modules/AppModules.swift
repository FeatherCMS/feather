import FeatherContracts
import FeatherApplication
import FeatherInfrastructure
import FeatherDatabase
import AuthApplication
import AuthInfrastructure
import UserInfrastructure
import MediaBackend
import AnalyticsBackend
import WebInfrastructure
import WebBackend
import NewsletterBackend
import RedirectBackend
import BlogBackend
import AccountBackend
import ContactBackend
import SystemBackend
import UserBackend
import AuthBackend
import NewsBackend

struct AppModules: Sendable {

    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    let system: SystemBackend.UseCases
    let analytics: AnalyticsBackend.UseCases
    let redirect: RedirectBackend.UseCases
    let web: WebBackend.UseCases
    let blog: BlogBackend.UseCases
    let news: NewsBackend.UseCases
    let user: UserBackend.UseCases
    let auth: AuthBackend.UseCases
    let media: MediaBackend.UseCases
    let contact: ContactBackend.UseCases
    let newsletter: NewsletterBackend.UseCases
    let account: AccountBackend.UseCases

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

        let system = SystemBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.system = system
        let analytics = AnalyticsBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.analytics = analytics
        let redirect = RedirectBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.redirect = redirect
        let news = NewsBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.news = news
        let user = UserBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            events: infrastructure.events
        )
        self.user = user
        let account = AccountBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            mailSender: JobQueueMailSender(queue: infrastructure.jobQueue),
            events: infrastructure.events,
            credentialWriter: InvitationCredentialWriterAdapter()
        )
        self.account = account
        let auth = AuthBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            user: self.user,
            mailSender: JobQueueMailSender(queue: infrastructure.jobQueue)
        )
        self.auth = auth
        let media = MediaBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            mediaStorageRootPath: infrastructure.mediaStorageRootPath,
            authorizer: authorizer,
            variantQueue: JobMediaVariantQueue(queue: infrastructure.jobQueue)
        )
        self.media = media
        let blog = BlogBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            media: media
        )
        self.blog = blog
        let web = WebBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.web = web
        let contact = ContactBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            mailQueue: JobContactMailQueue(queue: infrastructure.jobQueue)
        )
        self.contact = contact
        let newsletter = NewsletterBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            mailQueue: JobNewsletterMailQueue(queue: infrastructure.jobQueue)
        )
        self.newsletter = newsletter
    }
}
