import Hummingbird

struct AdminAddBlogAuthor {
    let controller: any AdminAddBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddBlogAuthorDefaultInteractor(
                        repository: AdminAddBlogAuthorOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddBlogAuthorDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
