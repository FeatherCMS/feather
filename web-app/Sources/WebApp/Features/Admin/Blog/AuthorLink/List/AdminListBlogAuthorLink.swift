import Hummingbird

struct AdminListBlogAuthorLink {
    let controller: any AdminListBlogAuthorLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListBlogAuthorLinkDefaultInteractor(
                        repository: AdminListBlogAuthorLinkOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListBlogAuthorLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
