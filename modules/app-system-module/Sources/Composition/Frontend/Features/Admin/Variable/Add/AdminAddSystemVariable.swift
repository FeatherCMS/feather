import FeatherAdmin
import Hummingbird

struct AdminAddSystemVariable {
    let controller: any AdminAddSystemVariableController

    init(apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminAddSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddSystemVariableDefaultInteractor(
                        repository: AdminAddSystemVariableOpenAPIRepository(
                            api: apiBuilder.makeSystemAdmin(context)
                        )
                    ),
                    presenter: AdminAddSystemVariableDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
