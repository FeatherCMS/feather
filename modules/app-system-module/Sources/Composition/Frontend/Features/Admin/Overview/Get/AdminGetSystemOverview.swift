import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminGetSystemOverview {
    let controller: any AdminGetSystemOverviewController

    init(renderingEngine: any RenderingEngine, events: any EventPublisher) {
        self.controller = AdminGetSystemOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetSystemOverviewDefaultInteractor(),
                    presenter: AdminGetSystemOverviewDefaultPresenter(
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
