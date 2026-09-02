import FeatherAdmin
import Hummingbird

struct AdminAddSystemVariable {
    let controller: any AdminAddSystemVariableController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddSystemVariableDefaultInteractor(
                        repository: AdminAddSystemVariableOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminAddSystemVariableDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
