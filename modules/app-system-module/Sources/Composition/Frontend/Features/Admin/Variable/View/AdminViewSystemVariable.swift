import FeatherAdmin
import Hummingbird

struct AdminViewSystemVariable {
    let controller: any AdminViewSystemVariableController

    init(
        apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewSystemVariableDefaultInteractor(
                        repository: AdminViewSystemVariableOpenAPIRepository(
                            api: apiBuilder.makeSystemAdmin(context)
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
