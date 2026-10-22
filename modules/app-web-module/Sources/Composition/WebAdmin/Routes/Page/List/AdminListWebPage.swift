import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebPage {
    let controller: any AdminListWebPageController

    init(
        apiBuilder: API.Builder,
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
