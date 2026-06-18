import Hummingbird

struct AdminGetBlogAuthor {
    let controller: any AdminGetBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetBlogAuthorDefaultInteractor(
                        repository: AdminGetBlogAuthorOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetBlogAuthorDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
