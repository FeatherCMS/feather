import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebPage {
    let controller: any AdminListWebPageController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListWebPageDefaultController(
            apiBuilder: apiBuilder,
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebPageDefaultInteractor(
                        repository: AdminListWebPageOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        )
                    ),
                    presenter: AdminListWebPageDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
