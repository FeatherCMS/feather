import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebMenuItem {
    let controller: any AdminRemoveWebMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveWebMenuItemDefaultInteractor(
                        repository: AdminRemoveWebMenuItemOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminRemoveWebMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
