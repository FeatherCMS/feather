import Hummingbird

struct AdminRemoveSystemVariable {
    let controller: any AdminRemoveSystemVariableController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveSystemVariableDefaultInteractor(
                        repository: AdminRemoveSystemVariableOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveSystemVariableDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
