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
    private let environment: AppEnvironment
    private let renderingEngine: any RenderingEngine

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        let authRoot = WebRoute.root
            .appending(pathComponent: "admin")
            .appending(pathComponent: "auth")
        let authBreadcrumb: [AdminBreadcrumb.Link] = [
            .init(label: "Admin", link: "/admin/"),
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
                identityRoot: WebRoute.root
                    .appending(pathComponent: "admin")
                    .appending(pathComponent: "auth")
                    .appending(pathComponent: "identities")
            ),
            environment: environment,
            renderingEngine: renderingEngine
        )
        .route(on: router)
    }
}
