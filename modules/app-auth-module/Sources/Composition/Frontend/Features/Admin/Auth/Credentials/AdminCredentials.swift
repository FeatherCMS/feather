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
import WebComponents
import WebBuilders

struct AdminCredentials {
    let renderingEngine: any RenderingEngine

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminListAuthCredential(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminAddAuthCredential(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminEditAuthCredential(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveAuthCredential(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
