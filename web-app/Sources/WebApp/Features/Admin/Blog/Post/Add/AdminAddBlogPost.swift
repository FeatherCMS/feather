import Hummingbird

struct AdminAddBlogPost {
    let controller: any AdminAddBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddBlogPostDefaultInteractor(
                        repository: AdminAddBlogPostOpenAPIRepository(
                            api: context.managementAPI()
                        ),
                        optionRepository:
                            AdminAddBlogPostOptionOpenAPIRepository(
                                api: context.managementAPI()
                            )
                    ),
                    presenter: AdminAddBlogPostDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
