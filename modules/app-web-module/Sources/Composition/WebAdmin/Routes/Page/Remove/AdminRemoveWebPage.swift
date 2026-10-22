import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebPage {
    let controller: any AdminRemoveWebPageController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveWebPageDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveWebPageDefaultInteractor(
                        repository: AdminRemoveWebPageOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminRemoveWebPageDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
