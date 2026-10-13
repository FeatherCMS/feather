import FeatherAdmin
import Hummingbird

struct AdminViewSystemOverview {
    let controller: any AdminViewSystemOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewSystemOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewSystemOverviewDefaultInteractor(),
                    presenter: AdminViewSystemOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
