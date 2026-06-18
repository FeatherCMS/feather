import Hummingbird

struct AdminGetAuthMagicLink {
    let controller: any AdminGetAuthMagicLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAuthMagicLinkDefaultInteractor(
                        repository: AdminGetAuthMagicLinkOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetAuthMagicLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
