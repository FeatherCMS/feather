import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebMenuItem {
    let controller: any AdminViewWebMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebMenuItemDefaultInteractor(
                        repository: AdminViewWebMenuItemOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminViewWebMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
