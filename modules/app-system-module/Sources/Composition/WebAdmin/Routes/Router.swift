public import FeatherWebAdmin
public import FeatherWebShared
public import FeatherModuleKit
public import Hummingbird
import SystemModule

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
                .appending(pathComponent: "system")
        )

        var breadcrumb: [AdminBreadcrumb.Link] {
            [
                .init(label: "Admin", link: admin.path),
                .init(label: "System", link: root.path),
            ]
        }
    }

    private let environment: AppEnvironment
    public let renderingEngine: any RenderingEngine
    private let adminEvents: any EventPublisher
    let routes: Routes

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
        AdminViewStyle(
            path: routes.admin.appending(pathComponent: "style.css")
        )
        .route(on: router)

        Dashboard
            .Router(
                renderingEngine: renderingEngine,
                events: adminEvents,
                path: routes.admin
            )
            .route(on: router)

        Overview
            .Router(
                renderingEngine: renderingEngine,
                routes: .init(root: routes.root)
            )
            .route(on: router)

        Permission.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: .init(
                root: routes.root,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)

        Variable.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: .init(
                root: routes.root,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)

        Job.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: .init(
                root: routes.root,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)
    }
}
