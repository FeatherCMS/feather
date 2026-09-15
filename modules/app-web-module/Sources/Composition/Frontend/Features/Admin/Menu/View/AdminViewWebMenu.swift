import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebMenu {
    let controller: any AdminViewWebMenuController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebMenuDefaultInteractor(
                        repository: AdminViewWebMenuOpenAPIRepository(
                            api: context.webAdminAPI()
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
