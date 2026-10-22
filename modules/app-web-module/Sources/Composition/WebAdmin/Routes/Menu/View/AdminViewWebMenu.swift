import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebMenu {
    let controller: any AdminViewWebMenuController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebMenuDefaultInteractor(
                        repository: AdminViewWebMenuOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminViewWebMenuDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
