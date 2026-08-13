import FeatherAdmin
import Hummingbird

struct AdminGetAccountHome {
    let controller: any AdminGetAccountHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAccountHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetAccountHomeDefaultInteractor(),
                    presenter: AdminGetAccountHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
