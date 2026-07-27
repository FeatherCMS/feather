import Hummingbird

struct AdminAccount {
    let renderingEngine: any RenderingEngine

    enum Scope {
        static let settings = PermissionScope(
            module: "account",
            resource: "settings"
        )
    }

    func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetAccountHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditAccountSettings(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
