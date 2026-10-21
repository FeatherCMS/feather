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

        AdminViewAuthOverview(
            renderingEngine: renderingEngine,
            credentialRoutes: credentialRoutes
        )
        .controller.route(on: router)

        AdminListAuthEmail(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAuthEmail(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddAuthEmail(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller
        .route(on: router)
        AdminEditAuthEmail(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller
        .route(on: router)
        AdminRemoveAuthEmail(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller
        .route(on: router)

        AdminListAuthMagicLink(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAuthMagicLink(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddAuthMagicLink(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthMagicLink(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveAuthMagicLink(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthAccessControl(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        Credential.Router(
            environment: environment,
            renderingEngine: renderingEngine,
            routes: credentialRoutes
        )
        .route(on: router)

        AdminListAuthSession(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller
        .route(on: router)
        AdminRemoveAuthSession(
            environment: environment,
            renderingEngine: renderingEngine
        )
        .controller
        .route(on: router)
    }
}
