import Hummingbird

struct AdminAddBlogTag {
    let controller: any AdminAddBlogTagController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddBlogTagDefaultInteractor(
                        repository: AdminAddBlogTagOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddBlogTagDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
