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
import SystemAdminAPI
import SystemAppAPI
import AnalyticsAdminAPI
import AnalyticsAppAPI
import RedirectAdminAPI
import RedirectAppAPI
import WebAdminAPI
import WebAppAPI
import BlogAdminAPI
import BlogAppAPI
import NewsAppAPI
import UserAdminAPI
import UserAppAPI
import AuthAdminAPI
import AuthAppAPI
import MediaAdminAPI
import ContactAdminAPI
import ContactAppAPI
import NewsletterAdminAPI
import NewsletterAppAPI
import AccountAdminAPI
import AccountAppAPI

struct AppModules: Sendable {

    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    let system: SystemBackend.UseCases
    let systemAdmin: any SystemAdminAPI.APIProtocol
    let systemApp: any SystemAppAPI.APIProtocol
    let analytics: AnalyticsBackend.UseCases
    let analyticsAdmin: any AnalyticsAdminAPI.APIProtocol
    let analyticsApp: any AnalyticsAppAPI.APIProtocol
    let redirect: RedirectBackend.UseCases
    let redirectAdmin: any RedirectAdminAPI.APIProtocol
    let redirectApp: any RedirectAppAPI.APIProtocol
    let web: WebBackend.UseCases
    let webAdmin: any WebAdminAPI.APIProtocol
    let webApp: any WebAppAPI.APIProtocol
    let blog: BlogBackend.UseCases
    let blogAdmin: any BlogAdminAPI.APIProtocol
    let blogApp: any BlogAppAPI.APIProtocol
    let news: NewsBackend.UseCases
    let newsApp: any NewsAppAPI.APIProtocol
    let user: UserBackend.UseCases
    let userAdmin: any UserAdminAPI.APIProtocol
    let userApp: any UserAppAPI.APIProtocol
    let auth: AuthBackend.UseCases
    let authAdmin: any AuthAdminAPI.APIProtocol
    let authApp: any AuthAppAPI.APIProtocol
    let media: MediaBackend.UseCases
    let mediaAdmin: any MediaAdminAPI.APIProtocol
    let contact: ContactBackend.UseCases
    let contactAdmin: any ContactAdminAPI.APIProtocol
    let contactApp: any ContactAppAPI.APIProtocol
    let newsletter: NewsletterBackend.UseCases
    let newsletterAdmin: any NewsletterAdminAPI.APIProtocol
    let newsletterApp: any NewsletterAppAPI.APIProtocol
    let account: AccountModule
    let accountBackend: AccountBackend.UseCases
    let accountAdmin: any AccountAdminAPI.APIProtocol
    let accountApp: any AccountAppAPI.APIProtocol

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
        self.systemAdmin = SystemBackend.AdminAPIGateway(useCases: system)
        self.systemApp = SystemBackend.AppAPIGateway(useCases: system)
        let analytics = AnalyticsBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.analytics = analytics
        self.analyticsAdmin = AnalyticsBackend.AdminAPIGateway(useCases: analytics)
        self.analyticsApp = AnalyticsBackend.AppAPIGateway(useCases: analytics)
        let redirect = RedirectBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.redirect = redirect
        self.redirectAdmin = RedirectBackend.AdminAPIGateway(useCases: redirect)
        self.redirectApp = RedirectBackend.AppAPIGateway(useCases: redirect)
        let news = NewsBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.news = news
        self.newsApp = NewsBackend.AppAPIGateway(useCases: news)
        let user = UserBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            events: infrastructure.events
        )
        self.user = user
        self.userAdmin = UserBackend.AdminAPIGateway(useCases: user)
        self.userApp = UserBackend.AppAPIGateway(useCases: user)
        let accountBackend = AccountBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            mailSender: JobQueueMailSender(queue: infrastructure.jobQueue),
            events: infrastructure.events
        )
        self.accountBackend = accountBackend
        self.accountAdmin = AccountBackend.AdminAPIGateway(useCases: accountBackend)
        self.accountApp = AccountBackend.AppAPIGateway(useCases: accountBackend)
        let auth = AuthBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            user: self.user
        )
        self.auth = auth
        self.authAdmin = AuthBackend.AdminAPIGateway(useCases: auth)
        self.authApp = AuthBackend.AppAPIGateway(useCases: auth)
        let media = MediaBackend.UseCases(
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

        self.media = media
        self.mediaAdmin = MediaBackend.AdminAPIGateway(useCases: media)
        let blog = BlogBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            media: media
        )
        self.blog = blog
        self.blogAdmin = BlogBackend.AdminAPIGateway(useCases: blog)
        self.blogApp = BlogBackend.AppAPIGateway(useCases: blog)
        let web = WebBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer
        )
        self.web = web
        self.webAdmin = WebBackend.AdminAPIGateway(useCases: web)
        self.webApp = WebBackend.AppAPIGateway(useCases: web)
        let contact = ContactBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            mailQueue: JobContactMailQueue(queue: infrastructure.jobQueue)
        )
        self.contact = contact
        self.contactAdmin = ContactBackend.AdminAPIGateway(useCases: contact)
        self.contactApp = ContactBackend.AppAPIGateway(useCases: contact)
        let newsletter = NewsletterBackend.UseCases(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            authorizer: authorizer,
            mailQueue: JobNewsletterMailQueue(queue: infrastructure.jobQueue)
        )
        self.newsletter = newsletter
        self.newsletterAdmin = NewsletterBackend.AdminAPIGateway(useCases: newsletter)
        self.newsletterApp = NewsletterBackend.AppAPIGateway(useCases: newsletter)
    }
}
