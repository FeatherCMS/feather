public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird
public import RedirectModule
import RedirectApplication

public struct Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let root: WebRoute
        public let rule: RedirectModule.Rule.Router.Routes

        public init(admin: WebRoute, root: WebRoute) {
            self.admin = admin
            self.root = root
            self.rule = .init(
                root: root,
                breadcrumb: [
                    .init(label: "Admin", link: admin.path),
                    .init(label: "Redirect", link: root.path),
                ]
            )
        }

        public static let standard = Routes(
            admin: WebRoute.root.appending(pathComponent: "admin"),
            root: WebRoute.root
                .appending(pathComponent: "admin")
                .appending(pathComponent: "redirect")
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
            path: routes.root,
            ruleRoutes: routes.rule
        )
        .route(on: router)

        RedirectModule.Rule.List.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: routes.rule
        )
        .route(on: router)

        RedirectModule.Rule.View.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: routes.rule
        )
        .route(on: router)

        RedirectModule.Rule.Add.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: routes.rule
        )
        .route(on: router)

        RedirectModule.Rule.Edit.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: routes.rule
        )
        .route(on: router)

        RedirectModule.Rule.Remove.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: routes.rule
        )
        .route(on: router)
    }
}
