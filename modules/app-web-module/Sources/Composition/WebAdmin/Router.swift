public import FeatherModuleKit
public import FeatherWebAdmin
import FeatherWebShared
public import Hummingbird
import OpenAPIRuntime
import WebDomain

public struct Router {
    private let apiBuilder: API.Builder
    public let renderingEngine: any RenderingEngine
    public let adminEvents: any EventPublisher

    public init(
        apiBuilder: API.Builder,
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher
    ) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
        self.adminEvents = adminEvents
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        Overview.Router(renderingEngine: renderingEngine)
            .route(on: router)

        Settings.Router(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        Page.Router(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine,
            events: adminEvents
        )
        .route(on: router)

        Menu.Router(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .route(on: router)

        MenuItem.Router(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .route(on: router)
    }
}
