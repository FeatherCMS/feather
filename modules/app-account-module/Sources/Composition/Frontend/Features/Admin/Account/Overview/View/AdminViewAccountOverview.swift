import FeatherAdmin
import Hummingbird

struct AdminViewAccountOverview {
    let controller: any AdminViewAccountOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAccountOverviewDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminViewAccountOverviewDefaultInteractor(),
                    presenter: AdminViewAccountOverviewDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
