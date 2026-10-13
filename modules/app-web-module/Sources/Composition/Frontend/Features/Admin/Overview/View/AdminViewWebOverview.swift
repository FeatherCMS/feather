import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebOverview {
    let controller: any AdminViewWebOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewWebOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebOverviewDefaultInteractor(),
                    presenter: AdminViewWebOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
