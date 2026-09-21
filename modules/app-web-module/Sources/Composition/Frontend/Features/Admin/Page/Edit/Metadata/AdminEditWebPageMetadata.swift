import FeatherAdmin
import FeatherContracts
import Hummingbird
import OpenAPIRuntime

struct AdminEditWebPageMetadata {
    let controller: any AdminEditWebPageMetadataController

    init(
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminEditWebPageMetadataDefaultController(
            renderingEngine: renderingEngine,
            adminEvents: events
        )
    }
}
