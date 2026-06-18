import Hummingbird

struct AdminRedirect {
    let renderingEngine: any RenderingEngine

    enum Scope {
        static let rules = PermissionScope(
            module: "redirect",
            resource: "rules"
        )
        static let notFound = PermissionScope(
            module: "redirect",
            resource: "not-found"
        )
    }

    func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetRedirectHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListRedirectRule(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetRedirectNotFound(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetRedirectRule(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddRedirectRule(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditRedirectRule(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveRedirectRule(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
