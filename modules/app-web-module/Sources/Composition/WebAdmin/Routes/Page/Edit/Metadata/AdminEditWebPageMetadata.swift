import FeatherModuleKit
import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminEditWebPageMetadata {
    let controller: any AdminEditWebPageMetadataController

    init(
        apiBuilder: API.Builder,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminEditWebPageMetadataDefaultController(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine,
            adminEvents: events
        )
    }
}
