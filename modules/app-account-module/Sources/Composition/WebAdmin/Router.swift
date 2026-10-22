import AccountModule
public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird

public struct Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let account: WebRoute
        let accountProfile: Profile.Router.Routes
        let settings: Settings.Router.Routes
        let invitation: Invitation.Router.Routes
        let overview: Overview.Router.Routes

        public init(admin: WebRoute) {
            let account = admin.appending(pathComponent: "account")
            let accountProfile = Profile.Router.Routes(root: admin)
            let settings = Settings.Router.Routes(root: admin)
            let invitation = Invitation.Router.Routes(root: admin)
            self.admin = admin
            self.account = account
            self.accountProfile = accountProfile
            self.settings = settings
            self.invitation = invitation
            self.overview = .init(
                root: admin,
                profile: accountProfile.profile,
                settings: settings.settings,
                invitations: invitation.invitations
            )
        }

        public static let standard = Routes(
            admin: WebRoute.root.appending(pathComponent: "admin")
        )
    }

    private let environment: AppEnvironment
    public let renderingEngine: any RenderingEngine
    private let routes: Routes

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Routes = .standard
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
        self.routes = routes
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        Overview.Router(
            renderingEngine: renderingEngine,
            routes: routes.overview
        )
        .route(on: router)

        Profile.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: routes.accountProfile
        )
        .route(on: router)

        Settings.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: routes.settings
        )
        .route(on: router)

        Invitation.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: routes.invitation
        )
        .route(on: router)
    }
}
