import FeatherAdmin
import Hummingbird

struct AdminGetSystemOverview {
    let controller: any AdminGetSystemOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetSystemOverviewDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetSystemOverviewDefaultInteractor(),
                    presenter: AdminGetSystemOverviewDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
