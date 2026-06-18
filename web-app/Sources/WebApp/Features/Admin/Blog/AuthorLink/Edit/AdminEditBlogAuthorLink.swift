import Hummingbird

struct AdminEditBlogAuthorLink {
    let controller: any AdminEditBlogAuthorLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogAuthorLinkDefaultInteractor(
                        repository: AdminEditBlogAuthorLinkOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditBlogAuthorLinkDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
