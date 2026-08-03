import Hummingbird

struct AdminCredentials {
    let renderingEngine: any RenderingEngine

    func route(
        on router: Router<AppRequestContext>
    ) {
        AdminListAuthCredentialAccount(
            renderingEngine: renderingEngine
        ).controller.route(on: router)
        AdminListAuthCredential(
            renderingEngine: renderingEngine
        ).controller.route(on: router)
        AdminAddAuthCredential(
            renderingEngine: renderingEngine
        ).controller.route(on: router)
        AdminEditAuthCredential(
            renderingEngine: renderingEngine
        ).controller.route(on: router)
        AdminRemoveAuthCredential(
            renderingEngine: renderingEngine
        ).controller.route(on: router)
    }
}
