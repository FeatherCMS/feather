import FeatherAdmin
import Hummingbird
import MediaFrontend
import OpenAPIRuntime

struct AdminEditWebPage {
    let controller: any AdminEditWebPageController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebPageDefaultInteractor(
                        repository: AdminEditWebPageOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context),
                            mediaAPI: apiBuilder.makeMediaAdmin(context)
                        )
                    ),
                    presenter: AdminEditWebPageDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
