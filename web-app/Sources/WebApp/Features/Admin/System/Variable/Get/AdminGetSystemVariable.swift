import Hummingbird

struct AdminGetSystemVariable {
    let controller: any AdminGetSystemVariableController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetSystemVariableDefaultInteractor(
                        repository: AdminGetSystemVariableOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetSystemVariableDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
