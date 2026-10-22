import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime

struct AdminEditWebPage {
    let controller: any AdminEditWebPageController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebPageDefaultInteractor(
                        repository: AdminEditWebPageOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            ),
                            mediaAPI: MediaAdminAPIClient(
                                environment: environment.environment,
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
