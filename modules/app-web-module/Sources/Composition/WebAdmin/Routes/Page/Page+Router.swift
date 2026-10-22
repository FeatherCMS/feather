import FeatherModuleKit
import FeatherWebAdmin
import Hummingbird
import WebDomain

extension Page {
    struct Router {
        let apiBuilder: API.Builder
        let renderingEngine: any RenderingEngine
        let events: any EventPublisher

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            AdminListWebPage(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminViewWebPage(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminAddWebPage(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminEditWebPage(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
            AdminEditWebPageMetadata(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                events: events
            )
            .controller.route(on: router)
            AdminRemoveWebPage(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller.route(on: router)
        }
    }
}
