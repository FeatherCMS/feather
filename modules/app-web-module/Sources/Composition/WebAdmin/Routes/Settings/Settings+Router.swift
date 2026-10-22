import FeatherWebAdmin
import Hummingbird
import WebDomain

extension Settings {
    struct Router {
        let apiBuilder: API.Builder
        let renderingEngine: any RenderingEngine

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            AdminEditWebSettings(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
        }
    }
}
