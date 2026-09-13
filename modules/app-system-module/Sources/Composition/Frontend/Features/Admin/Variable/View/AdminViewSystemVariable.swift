import FeatherAdmin
import Hummingbird

struct AdminViewSystemVariable {
    let controller: any AdminViewSystemVariableController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewSystemVariableDefaultInteractor(
                        repository: AdminViewSystemVariableOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminViewSystemVariableDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
