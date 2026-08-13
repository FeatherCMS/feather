import FeatherAdmin
import Hummingbird

struct AdminEditSystemVariable {
    let controller: any AdminEditSystemVariableController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditSystemVariableDefaultInteractor(
                        repository: AdminEditSystemVariableOpenAPIRepository(
                            api: context.systemManagementAPI()
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
