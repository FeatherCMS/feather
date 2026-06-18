import Hummingbird

struct AdminEditSystemVariable {
    let controller: any AdminEditSystemVariableController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditSystemVariableDefaultInteractor(
                        repository: AdminEditSystemVariableOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditSystemVariableDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
