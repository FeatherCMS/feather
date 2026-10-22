import FeatherWebAdmin
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime

struct AdminViewWebPage {
    let controller: any AdminViewWebPageController

    init(
        apiBuilder: API.Builder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebPageDefaultInteractor(
                        repository: AdminViewWebPageOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context),
                            mediaAPI: MediaAdminAPIClient(
                                environment: apiBuilder.environment,
                                requestContext: context
                            )
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
