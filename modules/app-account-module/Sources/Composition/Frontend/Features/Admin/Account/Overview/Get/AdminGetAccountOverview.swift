import FeatherAdmin
import Hummingbird

struct AdminGetAccountOverview {
    let controller: any AdminGetAccountOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAccountOverviewDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetAccountOverviewDefaultInteractor(),
                    presenter: AdminGetAccountOverviewDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
