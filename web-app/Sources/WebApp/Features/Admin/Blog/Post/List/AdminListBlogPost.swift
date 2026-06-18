import Hummingbird

struct AdminListBlogPost {
    let controller: any AdminListBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListBlogPostDefaultInteractor(
                        repository: AdminListBlogPostOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListBlogPostDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
