import FeatherWebAdmin
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime

struct AdminEditWebPage {
    let controller: any AdminEditWebPageController

    init(
        apiBuilder: API.Builder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebPageDefaultInteractor(
                        repository: AdminEditWebPageOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context),
                            mediaAPI: MediaAdminAPIClient(
                                environment: apiBuilder.environment,
                                requestContext: context
                            )
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
