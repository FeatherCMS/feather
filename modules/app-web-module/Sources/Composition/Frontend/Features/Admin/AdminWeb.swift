public import FeatherAdmin
public import FeatherContracts
public import Hummingbird
import OpenAPIRuntime

public struct AdminWeb {
    private let apiBuilder: WebAPIBuilder
    public let renderingEngine: any RenderingEngine
    public let adminEvents: any EventPublisher

    public init(apiBuilder: WebAPIBuilder,
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
        AdminViewWebOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebSettings(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

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
            events: adminEvents
        )
        .controller.route(on: router)

        AdminRemoveWebPage(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListWebMenu(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

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

        AdminListWebMenuItem(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewWebMenuItem(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddWebMenuItem(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebMenuItem(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveWebMenuItem(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
