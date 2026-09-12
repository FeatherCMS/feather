import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminGetDashboard {
    let controller: any AdminGetDashboardController

    init(
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminGetDashboardDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetDashboardDefaultInteractor(
                        events: events
                    ),
                    presenter: AdminGetDashboardDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine,
                        permissions: context.currentUserPermissions
                    )
                )
            }
        )
    }

}
