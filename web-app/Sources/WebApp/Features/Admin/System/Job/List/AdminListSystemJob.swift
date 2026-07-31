import Hummingbird

struct AdminListSystemJob {
    let controller: any AdminListSystemJobController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListSystemJobDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListSystemJobDefaultInteractor(
                        repository: AdminListSystemJobOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListSystemJobDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
