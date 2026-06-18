import Hummingbird

struct AdminRemoveAuthMagicLink {
    let controller: any AdminRemoveAuthMagicLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveAuthMagicLinkDefaultInteractor(
                        repository: AdminRemoveAuthMagicLinkOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveAuthMagicLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
