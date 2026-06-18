import Hummingbird

struct AdminAddAuthMagicLink {
    let controller: any AdminAddAuthMagicLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAuthMagicLinkDefaultInteractor(
                        repository: AdminAddAuthMagicLinkOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddAuthMagicLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
