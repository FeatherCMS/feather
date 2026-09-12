import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminRemoveSystemVariable {
    let controller: any AdminRemoveSystemVariableController

    init(events: any EventPublisher, renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveSystemVariableDefaultInteractor(
                        repository: AdminRemoveSystemVariableOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminRemoveSystemVariableDefaultPresenter(
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
