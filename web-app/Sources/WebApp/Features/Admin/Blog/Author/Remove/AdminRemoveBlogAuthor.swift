import Hummingbird

struct AdminRemoveBlogAuthor {
    let controller: any AdminRemoveBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveBlogAuthorDefaultInteractor(
                        repository: AdminRemoveBlogAuthorOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveBlogAuthorDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
