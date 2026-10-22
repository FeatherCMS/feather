import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebMenu {
    let controller: any AdminRemoveWebMenuController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveWebMenuDefaultInteractor(
                        repository: AdminRemoveWebMenuOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminRemoveWebMenuDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
