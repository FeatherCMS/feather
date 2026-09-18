import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
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
    private let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminViewAuthOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListAuthEmail(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAuthEmail(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddAuthEmail(renderingEngine: renderingEngine).controller
            .route(on: router)
        AdminEditAuthEmail(renderingEngine: renderingEngine).controller
            .route(on: router)
        AdminRemoveAuthEmail(renderingEngine: renderingEngine).controller
            .route(on: router)

        AdminListAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthAccessControl(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminCredential(
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminListAuthSession(renderingEngine: renderingEngine)
            .controller
            .route(on: router)
        AdminRemoveAuthSession(renderingEngine: renderingEngine)
            .controller
            .route(on: router)
    }
}
