import Hummingbird

struct AdminAddBlogAuthorLink {
    let controller: any AdminAddBlogAuthorLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddBlogAuthorLinkDefaultInteractor(
                        repository: AdminAddBlogAuthorLinkOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddBlogAuthorLinkDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
