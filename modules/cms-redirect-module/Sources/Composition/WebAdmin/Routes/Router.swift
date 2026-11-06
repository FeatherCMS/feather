public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird
import RedirectApplication
public import RedirectModule

public struct Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let root: WebRoute
        public let rule: Rule.Router.Routes

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

        Rule.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.rule
            )
            .route(on: router)

        Rule.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.rule
            )
            .route(on: router)

        Rule.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.rule
            )
            .route(on: router)

        Rule.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.rule
            )
            .route(on: router)

        Rule.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.rule
            )
            .route(on: router)
    }
}
