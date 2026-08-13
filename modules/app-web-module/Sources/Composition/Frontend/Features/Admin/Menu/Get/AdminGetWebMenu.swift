import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminGetWebMenu {
    let controller: any AdminGetWebMenuController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetWebMenuDefaultInteractor(
                        repository: AdminGetWebMenuOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminGetWebMenuDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
