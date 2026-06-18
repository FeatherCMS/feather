import Hummingbird

struct AdminListAuthMagicLink {
    let controller: any AdminListAuthMagicLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthMagicLinkDefaultInteractor(
                        repository: AdminListAuthMagicLinkOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListAuthMagicLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
