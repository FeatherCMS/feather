import Hummingbird

struct AdminEditBlogPost {
    let controller: any AdminEditBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogPostDefaultInteractor(
                        repository: AdminEditBlogPostOpenAPIRepository(
                            api: context.managementAPI()
                        ),
                        optionRepository:
                            AdminEditBlogPostOptionOpenAPIRepository(
                                api: context.managementAPI()
                            )
                    ),
                    presenter: AdminEditBlogPostDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
