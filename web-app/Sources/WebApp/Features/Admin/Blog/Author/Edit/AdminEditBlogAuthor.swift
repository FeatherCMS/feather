import Hummingbird

struct AdminEditBlogAuthor {
    let controller: any AdminEditBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogAuthorDefaultInteractor(
                        repository: AdminEditBlogAuthorOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditBlogAuthorDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
