import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebPage {
    let controller: any AdminRemoveWebPageController

    init(apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveWebPageDefaultInteractor(
                        repository: AdminRemoveWebPageOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveWebPageDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
