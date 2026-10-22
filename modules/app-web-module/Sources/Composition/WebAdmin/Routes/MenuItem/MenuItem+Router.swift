import FeatherWebAdmin
import Hummingbird
import WebDomain

extension MenuItem {
    struct Router {
        let apiBuilder: API.Builder
        let renderingEngine: any RenderingEngine

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            AdminListWebMenuItem(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminViewWebMenuItem(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminAddWebMenuItem(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminEditWebMenuItem(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminRemoveWebMenuItem(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
        }
    }
}
