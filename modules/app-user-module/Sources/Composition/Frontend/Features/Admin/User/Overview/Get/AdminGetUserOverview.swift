import FeatherAdmin
import Hummingbird

struct AdminGetUserOverview {
    let controller: any AdminGetUserOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetUserOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetUserOverviewDefaultInteractor(),
                    presenter: AdminGetUserOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
