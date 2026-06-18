import Hummingbird

struct AdminSystem {
    let renderingEngine: any RenderingEngine

    enum Scope {
        static let permissions = PermissionScope(
            module: "system",
            resource: "permissions"
        )
        static let variables = PermissionScope(
            module: "system",
            resource: "variables"
        )
    }

    func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetSystemHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListSystemPermission(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetSystemPermission(
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

        AdminGetSystemVariable(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
