import AuthAdminAPI
import AuthAppAPI
import CSS
public import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
public import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

public struct AdminAuth {
    private let apiBuilder: AuthAPIBuilder
    private let renderingEngine: any RenderingEngine

    public init(
        apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        AdminViewAuthOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListAuthEmail(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAuthEmail(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddAuthEmail(apiBuilder: apiBuilder, renderingEngine: renderingEngine).controller
            .route(on: router)
        AdminEditAuthEmail(apiBuilder: apiBuilder, renderingEngine: renderingEngine).controller
            .route(on: router)
        AdminRemoveAuthEmail(apiBuilder: apiBuilder, renderingEngine: renderingEngine).controller
            .route(on: router)

        AdminListAuthMagicLink(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAuthMagicLink(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddAuthMagicLink(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthMagicLink(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveAuthMagicLink(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthAccessControl(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminCredential(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminListAuthSession(apiBuilder: apiBuilder, renderingEngine: renderingEngine)
            .controller
            .route(on: router)
        AdminRemoveAuthSession(apiBuilder: apiBuilder, renderingEngine: renderingEngine)
            .controller
            .route(on: router)
    }
}
