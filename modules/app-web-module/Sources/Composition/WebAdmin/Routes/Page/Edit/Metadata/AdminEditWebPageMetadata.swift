import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminEditWebPageMetadata {
    let controller: any AdminEditWebPageMetadataController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminEditWebPageMetadataDefaultController(
            environment: environment,
            renderingEngine: renderingEngine,
            adminEvents: events
        )
    }
}
