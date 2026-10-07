import FeatherContracts
import FeatherInfrastructure
import AuthApplication
import AuthInfrastructure
import UserInfrastructure
import MediaBackend
import MediaInfrastructure
import AnalyticsBackend
import WebBackend
import NewsletterBackend
import NewsletterInfrastructure
import RedirectBackend
import BlogBackend
import AccountBackend
import ContactBackend
import ContactInfrastructure
import SystemBackend
import UserBackend
import AuthBackend
import NewsBackend

struct AppModules: Sendable {

    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer
    let mediaResolver: MediaResolver

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
        infrastructure: AppInfrastructure,
        mediaResolver: MediaResolver
    ) {
        self.infrastructure = infrastructure
        self.mediaResolver = mediaResolver

        let query = DatabaseQueryExecutor(
            databaseContext: infrastructure.databaseContext,
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
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer
        )
        self.system = system
        let analytics = AnalyticsBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer
        )
        self.analytics = analytics
        let redirect = RedirectBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer
        )
        self.redirect = redirect
        let news = NewsBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer
        )
        self.news = news
        let user = UserBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer,
            events: infrastructure.events
        )
        self.user = user
        let account = AccountBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer,
            jobs: JobQueueSendMailJobController(queue: infrastructure.jobQueue),
            events: infrastructure.events
        )
        self.account = account
        let auth = AuthBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer,
            jobs: JobQueueSendMailJobController(queue: infrastructure.jobQueue)
        )
        self.auth = auth
        let media = MediaBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            storageContext: infrastructure.storageContext,
            authorizer: authorizer,
            jobs: JobQueueMediaJobController(queue: infrastructure.jobQueue)
        )
        self.media = media
        let blog = BlogBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer,
            media: media,
            mediaResolver: mediaResolver
        )
        self.blog = blog
        let web = WebBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer
        )
        self.web = web
        let contact = ContactBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer,
            jobs: JobQueueSendMailJobController(queue: infrastructure.jobQueue),
            events: infrastructure.events
        )
        self.contact = contact
        let newsletter = NewsletterBackend.UseCases(
            databaseContext: infrastructure.databaseContext,
            authorizer: authorizer,
            jobs: JobQueueNewsletterIssueJobController(
                queue: infrastructure.jobQueue,
                mailJobs: JobQueueSendMailJobController(
                    queue: infrastructure.jobQueue
                )
            )
        )
        self.newsletter = newsletter
    }
}
