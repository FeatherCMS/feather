import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebMenuItem {
    let controller: any AdminViewWebMenuItemController

    init(apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminViewWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebMenuItemDefaultInteractor(
                        repository: AdminViewWebMenuItemOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
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
