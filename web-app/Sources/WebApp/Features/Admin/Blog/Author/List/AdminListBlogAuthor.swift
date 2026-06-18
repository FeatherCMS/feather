import Hummingbird

struct AdminListBlogAuthor {
    let controller: any AdminListBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListBlogAuthorDefaultInteractor(
                        repository: AdminListBlogAuthorOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListBlogAuthorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
