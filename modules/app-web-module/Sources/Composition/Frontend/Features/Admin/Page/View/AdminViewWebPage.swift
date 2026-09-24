import FeatherAdmin
import Hummingbird
import MediaFrontend
import OpenAPIRuntime

struct AdminViewWebPage {
    let controller: any AdminViewWebPageController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebPageDefaultInteractor(
                        repository: AdminViewWebPageOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context),
                            mediaAPI: apiBuilder.makeMediaAdmin(context)
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
