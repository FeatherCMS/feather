import FeatherAdmin
import Hummingbird

struct AdminRemoveSystemVariable {
    let controller: any AdminRemoveSystemVariableController

    init(apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveSystemVariableDefaultInteractor(
                        repository: AdminRemoveSystemVariableOpenAPIRepository(
                            api: apiBuilder.makeSystemAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveSystemVariableDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
