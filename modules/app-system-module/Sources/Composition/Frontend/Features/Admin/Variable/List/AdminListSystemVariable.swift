import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminListSystemVariable {
    let controller: any AdminListSystemVariableController

    init(
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminListSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListSystemVariableDefaultInteractor(
                        repository: AdminListSystemVariableOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminListSystemVariableDefaultPresenter(
                        request: request,
                        context: context,
                        events: events,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
