import FeatherAdmin
import Hummingbird

public struct AdminUser {
    public let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public enum Scope {
        public static let identities = PermissionScope(
            module: "user",
            resource: "identities"
        )
        public static let roles = PermissionScope(
            module: "user",
            resource: "roles"
        )
    }

    public func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetUserHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListUserIdentity(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetUserIdentity(
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

        AdminGetUserRole(
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
