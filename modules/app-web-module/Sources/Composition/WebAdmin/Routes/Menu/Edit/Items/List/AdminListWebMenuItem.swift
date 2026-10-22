import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminListWebMenuItem {
    let controller: any AdminListWebMenuItemController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebMenuItemDefaultInteractor(
                        repository: AdminListWebMenuItemOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminListWebMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
