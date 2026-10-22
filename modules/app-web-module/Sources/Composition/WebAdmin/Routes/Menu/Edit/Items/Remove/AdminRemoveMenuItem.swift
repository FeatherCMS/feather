import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveMenuItem {
    let controller: any AdminRemoveMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveMenuItemDefaultInteractor(
                        repository: AdminRemoveMenuItemOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminRemoveMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
