public import FeatherWebAdmin
public import Hummingbird
import UserModule

public struct Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let user: WebRoute

        public init(admin: WebRoute, user: WebRoute) {
            self.admin = admin
            self.user = user
        }

        public static let standard = Routes(
            admin: WebRoute.root.appending(pathComponent: "admin"),
            user: WebRoute.root
                .appending(pathComponent: "admin")
                .appending(pathComponent: "user")
        )

        var breadcrumb: [AdminBreadcrumb.Link] {
            [
                .init(label: "Admin", link: admin.path),
                .init(label: "User", link: user.path),
            ]
        }
    }

    private let environment: AppEnvironment
    public let renderingEngine: any RenderingEngine
    let routes: Routes

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
            routes: .init(root: routes.user)
        )
        .route(on: router)

        Identity.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: .init(root: routes.user, breadcrumb: routes.breadcrumb)
        )
        .route(on: router)

        Role.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: .init(root: routes.user, breadcrumb: routes.breadcrumb)
        )
        .route(on: router)
    }
}
