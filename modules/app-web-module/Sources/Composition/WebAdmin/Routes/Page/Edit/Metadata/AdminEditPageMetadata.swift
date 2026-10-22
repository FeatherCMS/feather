import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminEditPageMetadata {
    let controller: any AdminEditPageMetadataController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminEditPageMetadataDefaultController(
            environment: environment,
            renderingEngine: renderingEngine,
            adminEvents: events
        )
    }
}
