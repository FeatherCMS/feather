public import FeatherAdmin
public import FeatherContracts
public import Hummingbird

public struct AdminSystem {
    private let apiBuilder: SystemAPIBuilder
    public let renderingEngine: any RenderingEngine
    private let adminEvents: any EventPublisher

    public init(apiBuilder: SystemAPIBuilder,
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
        AdminViewStyle()
            .route(on: router)

        AdminViewDashboard(
            apiBuilder: apiBuilder,
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
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewSystemPermission(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddSystemPermission(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditSystemPermission(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveSystemPermission(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListSystemVariable(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddSystemVariable(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditSystemVariable(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveSystemVariable(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewSystemVariable(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListSystemJob(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewSystemJob(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
