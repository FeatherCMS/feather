import Hummingbird

struct AdminEditAuthMagicLink {
    let controller: any AdminEditAuthMagicLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthMagicLinkDefaultInteractor(
                        repository: AdminEditAuthMagicLinkOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditAuthMagicLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
