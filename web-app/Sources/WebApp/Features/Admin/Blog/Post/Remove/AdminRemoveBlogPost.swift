import Hummingbird

struct AdminRemoveBlogPost {
    let controller: any AdminRemoveBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveBlogPostDefaultInteractor(
                        repository: AdminRemoveBlogPostOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveBlogPostDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
