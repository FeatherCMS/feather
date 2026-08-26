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
import WebStandards

struct AdminAuth {
    let renderingEngine: any RenderingEngine

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminGetAuthHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetAuthMagicLink(
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

        AdminGetAuthProfile(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthProfile(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthAccessControl(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminCredentials(
            renderingEngine: renderingEngine
        )
        .route(on: router)
    }
}
