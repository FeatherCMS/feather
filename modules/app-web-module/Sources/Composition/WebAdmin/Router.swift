public import FeatherModuleKit
public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird
import OpenAPIRuntime
import WebDomain

public struct Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let root: WebRoute

        public init(admin: WebRoute, root: WebRoute) {
            self.admin = admin
            self.root = root
        }

        public static let standard = Routes(
            admin: WebRoute.root.appending(pathComponent: "admin"),
            root: WebRoute.root
                .appending(pathComponent: "admin")
                .appending(pathComponent: "web")
        )

        var breadcrumb: [AdminBreadcrumb.Link] {
            [
                .init(label: "Admin", link: admin.path),
                .init(label: "Web", link: root.path),
            ]
        }
    }

    private let environment: AppEnvironment
    public let renderingEngine: any RenderingEngine
    public let adminEvents: any EventPublisher
    public let routes: Routes

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher,
        routes: Routes = .standard
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
        self.adminEvents = adminEvents
        self.routes = routes
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        Overview.Router(
            renderingEngine: renderingEngine,
            path: routes.root
        )
        .route(on: router)

        Settings.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            root: routes.root
        )
        .route(on: router)

        Page.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            events: adminEvents,
            root: routes.root
        )
        .route(on: router)

        Menu.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            root: routes.root
        )
        .route(on: router)

        MenuItem.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            root: routes.root
        )
        .route(on: router)
    }
}
