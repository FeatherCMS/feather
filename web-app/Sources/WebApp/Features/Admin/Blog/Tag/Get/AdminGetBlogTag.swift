import Hummingbird

struct AdminGetBlogTag {
    let controller: any AdminGetBlogTagController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetBlogTagDefaultInteractor(
                        repository: AdminGetBlogTagOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetBlogTagDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
