import FeatherAdmin
import Hummingbird

public struct AccountAdmin {
    public let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public enum Scope {
        public static let settings = PermissionScope(
            module: "account",
            resource: "settings"
        )
        public static let invitations = PermissionScope(
            module: "account",
            resource: "invitations"
        )
    }

    public func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetAccountHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditSettings(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListAccountInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetAccountInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddAccountInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAccountInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveAccountInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
