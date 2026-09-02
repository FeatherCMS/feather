import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebPage {
    let controller: any AdminListWebPageController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebPageDefaultInteractor(
                        repository: AdminListWebPageOpenAPIRepository(
                            api: context.webAdminAPI()
                        )
                    ),
                    presenter: AdminListWebPageDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
