import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime

struct AdminViewWebPage {
    let controller: any AdminViewWebPageController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebPageDefaultInteractor(
                        repository: AdminViewWebPageOpenAPIRepository(
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
