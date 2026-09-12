import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminListSystemVariable {
    static let pageSize = 20

    let controller: any AdminListSystemVariableController

    init(
        events: any EventPublisher,
        renderingEngine: any RenderingEngine
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
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
