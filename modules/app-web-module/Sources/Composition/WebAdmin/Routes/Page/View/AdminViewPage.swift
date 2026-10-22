import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime

struct AdminViewPage {
    let controller: any AdminViewPageController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewPageDefaultInteractor(
                        repository: AdminViewPageOpenAPIRepository(
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
                    presenter: AdminViewPageDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
