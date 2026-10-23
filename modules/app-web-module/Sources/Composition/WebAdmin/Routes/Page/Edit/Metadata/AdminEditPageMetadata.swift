import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

struct AdminEditPageMetadata {
    let controller: any AdminEditPageMetadataController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher,
        routes: Page.Router.Routes
    ) {
        self.controller = AdminEditPageMetadataDefaultController(
            environment: environment,
            renderingEngine: renderingEngine,
            adminEvents: events,
            routes: routes
        )
    }
}
