import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveMenu {
    let controller: any AdminRemoveMenuController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveMenuDefaultInteractor(
                        repository: AdminRemoveMenuOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminRemoveMenuDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
