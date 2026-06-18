import Hummingbird

struct AdminEditBlogTag {
    let controller: any AdminEditBlogTagController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogTagDefaultInteractor(
                        repository: AdminEditBlogTagOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditBlogTagDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
