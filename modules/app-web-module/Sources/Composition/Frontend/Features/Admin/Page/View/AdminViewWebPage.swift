import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebPage {
    let controller: any AdminViewWebPageController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebPageDefaultInteractor(
                        repository: AdminViewWebPageOpenAPIRepository(
                            api: context.webAdminAPI()
                        )
                    ),
                    presenter: AdminViewWebPageDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
