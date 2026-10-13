import FeatherAdmin
import FeatherContracts

struct AdminViewDashboard {
    let controller: any AdminViewDashboardController

    init(
        apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminViewDashboardDefaultController(
            apiBuilder: apiBuilder,
            buildRuntime: { request, context in
                (
                    interactor: AdminViewDashboardDefaultInteractor(
                        events: events
                    ),
                    presenter: AdminViewDashboardDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine,
                    )
                )
            }
        )
    }

}
