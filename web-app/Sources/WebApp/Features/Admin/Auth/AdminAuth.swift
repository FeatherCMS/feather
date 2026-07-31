import Hummingbird

struct AdminAuth {
    let renderingEngine: any RenderingEngine

    enum Scope {
        static let magicLinks = PermissionScope(
            module: "auth",
            resource: "magic-links"
        )
        static let profile = PermissionScope(
            module: "auth",
            resource: "profile"
        )
        static let accessControl = PermissionScope(
            module: "auth",
            resource: "access-control"
        )
        static let credentials = PermissionScope(
            module: "auth",
            resource: "credential"
        )
    }

    func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetAuthHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveAuthMagicLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetAuthProfile(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthProfile(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAuthAccessControl(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminCredentials(
            renderingEngine: renderingEngine
        )
        .route(on: router)
    }
}
