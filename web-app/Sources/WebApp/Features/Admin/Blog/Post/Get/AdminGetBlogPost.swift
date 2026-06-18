import Hummingbird

struct AdminGetBlogPost {
    let controller: any AdminGetBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetBlogPostDefaultInteractor(
                        repository: AdminGetBlogPostOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetBlogPostDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
