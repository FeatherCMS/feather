import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminGetWebPage {
    let controller: any AdminGetWebPageController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetWebPageDefaultInteractor(
                        repository: AdminGetWebPageOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminGetWebPageDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
