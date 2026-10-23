import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime

struct AdminEditPage {
    let controller: any AdminEditPageController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditPageDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminEditPageDefaultInteractor(
                        repository: AdminEditPageOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            ),
                            mediaAPI: MediaAdminAPIClient(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminEditPageDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
