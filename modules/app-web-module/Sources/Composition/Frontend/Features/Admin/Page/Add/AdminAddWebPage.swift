import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminAddWebPage {
    let controller: any AdminAddWebPageController

    init(apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminAddWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebPageDefaultInteractor(
                        repository: AdminAddWebPageOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        )
                    ),
                    presenter: AdminAddWebPageDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
