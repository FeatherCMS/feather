import FeatherWebAdmin
import Hummingbird
import WebDomain

extension Menu {
    struct Router {
        let apiBuilder: API.Builder
        let renderingEngine: any RenderingEngine

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            List.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)
            AdminViewWebMenu(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminAddWebMenu(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminEditWebMenu(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminRemoveWebMenu(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
        }
    }
}
