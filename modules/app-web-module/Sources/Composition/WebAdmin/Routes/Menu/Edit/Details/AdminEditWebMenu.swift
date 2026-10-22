import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

struct AdminEditWebMenu {
    let controller: any AdminEditWebMenuController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMenuDefaultInteractor(
                        repository: AdminEditWebMenuOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminEditWebMenuDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
