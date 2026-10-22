import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminAddWebMenu {
    let controller: any AdminAddWebMenuController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebMenuDefaultInteractor(
                        repository: AdminAddWebMenuOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminAddWebMenuDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
