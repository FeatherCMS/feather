import Hummingbird

struct AdminRemoveBlogTag {
    let controller: any AdminRemoveBlogTagController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveBlogTagDefaultInteractor(
                        repository: AdminRemoveBlogTagOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveBlogTagDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
