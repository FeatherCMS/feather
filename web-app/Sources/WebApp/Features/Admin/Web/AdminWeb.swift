import Hummingbird

struct AdminWeb {
    let renderingEngine: any RenderingEngine

    enum Scope {
        static let pages = PermissionScope(
            module: "web",
            resource: "pages"
        )
        static let metadata = PermissionScope(
            module: "web",
            resource: "metadata"
        )
        static let menus = PermissionScope(
            module: "web",
            resource: "menus"
        )
        static let menuItems = PermissionScope(
            module: "web",
            resource: "menu-items"
        )
        static let settings = PermissionScope(
            module: "web",
            resource: "settings"
        )
    }

    func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetWebHome(
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

        AdminGetWebPage(
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

        AdminRemoveWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListWebMetadata(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetWebMetadata(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebMetadata(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetWebMenu(
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

        AdminGetWebMenuItem(
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
