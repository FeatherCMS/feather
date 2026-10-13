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

struct AdminCredential {
    let apiBuilder: AuthAPIBuilder
    let renderingEngine: any RenderingEngine

    init(apiBuilder: AuthAPIBuilder, renderingEngine: any RenderingEngine) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
    }

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        AdminListAuthCredential(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminAddAuthCredential(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminEditAuthCredential(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveAuthCredential(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
