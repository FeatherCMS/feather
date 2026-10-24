public import FeatherModuleKit
public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

public struct Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let root: WebRoute
        public let pages: WebRoute
        public let menus: WebRoute
        public let settings: WebRoute

        public init(admin: WebRoute, root: WebRoute) {
            self.admin = admin
            self.root = root
            self.pages = root.appending(pathComponent: "pages")
            self.menus = root.appending(pathComponent: "menus")
            self.settings = root.appending(pathComponent: "settings")
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
        let menuRoutes = Menu.Router.Routes(
            root: routes.menus,
            breadcrumb: routes.breadcrumb
        )

        Overview.Router(
            renderingEngine: renderingEngine,
            routes: .init(
                root: routes.root,
                pages: routes.pages,
                menus: routes.menus,
                settings: routes.settings,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)

        Settings.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: .init(
                edit: routes.settings,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)

        Page.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            events: adminEvents,
            routes: .init(
                root: routes.pages,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)

        Menu.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: menuRoutes
        )
        .route(on: router)

    }
}
