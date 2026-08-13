import FeatherAdmin
import FeatherApplication
import FeatherContracts
import Hummingbird

struct AdminGetHome {
    let controller: any AdminGetHomeController

    init(
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        self.controller = AdminGetHomeDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetHomeDefaultInteractor(
                        events: events
                    ),
                    presenter: AdminGetHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine,
                        permissions: context.currentUserPermissions
                    )
                )
            }
        )
    }

}
