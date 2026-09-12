import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminEditSystemVariable {
    let controller: any AdminEditSystemVariableController

    init(events: any EventPublisher, renderingEngine: any RenderingEngine) {
        self.controller = AdminEditSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditSystemVariableDefaultInteractor(
                        repository: AdminEditSystemVariableOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminEditSystemVariableDefaultPresenter(
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
