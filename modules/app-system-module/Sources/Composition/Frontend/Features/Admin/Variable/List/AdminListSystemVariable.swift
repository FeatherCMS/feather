import FeatherAdmin
import Hummingbird

struct AdminListSystemVariable {
    let controller: any AdminListSystemVariableController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListSystemVariableDefaultInteractor(
                        repository: AdminListSystemVariableOpenAPIRepository(
                            api: context.systemManagementAPI()
                        )
                    ),
                    presenter: AdminListSystemVariableDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
