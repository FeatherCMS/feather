import Hummingbird

struct AdminListBlogTag {
    let controller: any AdminListBlogTagController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListBlogTagDefaultInteractor(
                        repository: AdminListBlogTagOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListBlogTagDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
