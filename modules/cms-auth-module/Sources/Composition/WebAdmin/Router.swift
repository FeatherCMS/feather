import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
public import FeatherWebAdmin
public import FeatherWebShared
import HTML
public import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

public struct Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let auth: WebRoute

        public init(admin: WebRoute, auth: WebRoute) {
            self.admin = admin
            self.auth = auth
        }

        public static let standard = Routes(
            admin: WebRoute.root.appending(pathComponent: "admin"),
            auth: WebRoute.root
                .appending(pathComponent: "admin")
                .appending(pathComponent: "auth")
        )
    }

    private let environment: AppEnvironment
    private let renderingEngine: any RenderingEngine
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
        let authRoot = routes.auth
        AuthLookup.Router(
            environment: environment,
            path: authRoot.appending(pathComponent: "autocomplete")
        ).route(on: router)
        let authBreadcrumb: [AdminBreadcrumb.Link] = [
            .init(label: "Admin", link: routes.admin.path),
            .init(label: "Auth", link: authRoot.path),
        ]
        let credentialRoutes = Credential.Router.Routes(
            root: authRoot,
            breadcrumb: authBreadcrumb
        )
        let emailRoutes = Email.Router.Routes(
            root: authRoot,
            breadcrumb: authBreadcrumb
        )
        let magicLinkRoutes = MagicLink.Router.Routes(
            root: authRoot,
            breadcrumb: authBreadcrumb
        )
        let accessControlRoutes = RolePermission.Router.Routes(
            root: authRoot,
            breadcrumb: authBreadcrumb
        )

        Overview.Router(
            renderingEngine: renderingEngine,
            routes: .init(
                path: authRoot,
                breadcrumb: authBreadcrumb,
                email: emailRoutes,
                credential: credentialRoutes,
                magicLink: magicLinkRoutes,
                accessControl: accessControlRoutes
            )
        )
        .route(on: router)

        Email.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: emailRoutes
        )
        .route(on: router)

        MagicLink.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: magicLinkRoutes
        )
        .route(on: router)

        RolePermission.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: accessControlRoutes
        )
        .route(on: router)

        Credential.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: credentialRoutes
        )
        .route(on: router)

        Session.Router(
            routes: Session.Router.Routes(
                admin: routes.admin,
                auth: routes.auth,
                identityRoot: routes.auth
                    .appending(pathComponent: "identities"),
                magicLinks: magicLinkRoutes.list
            ),
            environment: environment,
            renderingEngine: renderingEngine
        )
        .route(on: router)
    }
}
