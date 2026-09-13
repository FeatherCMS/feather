import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminViewDashboard {
    let controller: any AdminViewDashboardController

    init(
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminViewDashboardDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewDashboardDefaultInteractor(
                        events: events
                    ),
                    presenter: AdminViewDashboardDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine,
                        permissions: context.currentUserPermissions
                    )
                )
            }
        )
    }

}
