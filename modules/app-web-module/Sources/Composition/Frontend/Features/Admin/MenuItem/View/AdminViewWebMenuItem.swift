import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebMenuItem {
    let controller: any AdminViewWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebMenuItemDefaultInteractor(
                        repository: AdminViewWebMenuItemOpenAPIRepository(
                            api: context.webAdminAPI()
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
