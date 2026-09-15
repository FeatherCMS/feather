import FeatherAdmin
import FeatherContracts
import Hummingbird

public struct AdminSystem {
    public let renderingEngine: any RenderingEngine
    private let adminEvents: any EventPublisher

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
        AdminViewStyle()
            .route(on: router)

        AdminViewDashboard(
            renderingEngine: renderingEngine,
            events: adminEvents
        )
        .controller.route(on: router)

        AdminViewSystemOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewDesignSystem(
            renderingEngine: renderingEngine,
            events: adminEvents
        )
        .controller.route(on: router)

        AdminListSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListSystemJob(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewSystemJob(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
