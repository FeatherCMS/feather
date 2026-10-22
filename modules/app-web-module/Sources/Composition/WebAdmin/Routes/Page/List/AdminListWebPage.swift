import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminListWebPage {
    let controller: any AdminListWebPageController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListWebPageDefaultController(
            environment: environment,
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebPageDefaultInteractor(
                        repository: AdminListWebPageOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
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
