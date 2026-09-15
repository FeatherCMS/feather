import FeatherAdmin
import Hummingbird

struct AdminViewUserOverview {
    let controller: any AdminViewUserOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewUserOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewUserOverviewDefaultInteractor(),
                    presenter: AdminViewUserOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
