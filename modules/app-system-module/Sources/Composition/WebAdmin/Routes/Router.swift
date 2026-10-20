public import FeatherAdmin
public import FeatherModuleKit
public import Hummingbird

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

    private let apiBuilder: API.Builder
    public let renderingEngine: any RenderingEngine
    private let adminEvents: any EventPublisher
    let routes: Routes

    public init(
        apiBuilder: API.Builder,
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher,
        routes: Routes = .standard
    ) {
        self.apiBuilder = apiBuilder
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
                apiBuilder: apiBuilder,
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
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine,
            routes: .init(
                root: routes.root,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)

        Variable.Router(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine,
            routes: .init(
                root: routes.root,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)

        Job.Router(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine,
            routes: .init(
                root: routes.root,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)
    }
}
