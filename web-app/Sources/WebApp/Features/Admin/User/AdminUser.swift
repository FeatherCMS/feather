import Hummingbird

struct AdminUser {
    let renderingEngine: any RenderingEngine

    enum Scope {
        static let accounts = PermissionScope(
            module: "user",
            resource: "accounts"
        )
        static let roles = PermissionScope(
            module: "user",
            resource: "roles"
        )
        static let invitations = PermissionScope(
            module: "user",
            resource: "invitations"
        )
    }

    func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetUserHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListUserAccount(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetUserAccount(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddUserAccount(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditUserAccount(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveUserAccount(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveUserAccountSession(
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

        AdminListUserInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetUserInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddUserInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditUserInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveUserInvitation(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
