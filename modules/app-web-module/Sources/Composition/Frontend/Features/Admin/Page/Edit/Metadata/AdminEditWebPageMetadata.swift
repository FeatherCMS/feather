import FeatherAdmin
import FeatherContracts
import Hummingbird
import OpenAPIRuntime

struct AdminEditWebPageMetadata {
    let controller: any AdminEditWebPageMetadataController

    init(
        apiBuilder: WebAPIBuilder,
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
