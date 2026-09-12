import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminAddSystemVariable {
    let controller: any AdminAddSystemVariableController

    init(events: any EventPublisher, renderingEngine: any RenderingEngine) {
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
                        context: context,
                        events: events,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
