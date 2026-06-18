import Hummingbird

struct AdminRemoveBlogAuthorLink {
    let controller: any AdminRemoveBlogAuthorLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveBlogAuthorLinkDefaultInteractor(
                        repository: AdminRemoveBlogAuthorLinkOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveBlogAuthorLinkDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
