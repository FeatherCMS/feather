import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminGetWebHome {
    let controller: any AdminGetWebHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetWebHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetWebHomeDefaultInteractor(),
                    presenter: AdminGetWebHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
