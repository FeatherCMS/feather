import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminAddWebPage {
    let controller: any AdminAddWebPageController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebPageDefaultInteractor(
                        repository: AdminAddWebPageOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminAddWebPageDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
