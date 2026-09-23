import FeatherAdmin
import Hummingbird

struct AdminEditSystemVariable {
    let controller: any AdminEditSystemVariableController

    init(apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminEditSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditSystemVariableDefaultInteractor(
                        repository: AdminEditSystemVariableOpenAPIRepository(
                            api: apiBuilder.makeSystemAdmin(context)
                        )
                    ),
                    presenter: AdminEditSystemVariableDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
