import FeatherAdmin
import FeatherContracts
import Hummingbird
import OpenAPIRuntime

public struct AdminWeb {
    public let renderingEngine: any RenderingEngine
    public let adminEvents: any EventPublisher

    public init(
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher
    ) {
        self.renderingEngine = renderingEngine
        self.adminEvents = adminEvents
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminViewWebOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebSettings(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminWebPageMetadataRoutes.register(
            router: router,
            renderingEngine: renderingEngine,
            events: adminEvents
        )

        AdminRemoveWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListWebMenuItem(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewWebMenuItem(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddWebMenuItem(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebMenuItem(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveWebMenuItem(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
