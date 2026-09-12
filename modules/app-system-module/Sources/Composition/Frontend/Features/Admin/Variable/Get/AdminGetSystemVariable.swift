import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminGetSystemVariable {
    let controller: any AdminGetSystemVariableController

    init(renderingEngine: any RenderingEngine, events: any EventPublisher) {
        self.controller = AdminGetSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetSystemVariableDefaultInteractor(
                        repository: AdminGetSystemVariableOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminGetSystemVariableDefaultPresenter(
                        request: request,
                        context: context,
                        events: events,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
