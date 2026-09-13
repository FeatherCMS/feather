import FeatherAdmin
import Hummingbird

public struct AdminUser {
    public let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminViewUserOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListUserIdentity(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewUserIdentity(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveUserIdentity(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddUserIdentity(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditUserIdentity(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListUserRole(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewUserRole(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddUserRole(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditUserRole(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveUserRole(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

    }
}
