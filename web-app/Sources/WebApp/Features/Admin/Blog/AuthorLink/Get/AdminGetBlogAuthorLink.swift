import Hummingbird

struct AdminGetBlogAuthorLink {
    let controller: any AdminGetBlogAuthorLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetBlogAuthorLinkDefaultInteractor(
                        repository: AdminGetBlogAuthorLinkOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetBlogAuthorLinkDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
