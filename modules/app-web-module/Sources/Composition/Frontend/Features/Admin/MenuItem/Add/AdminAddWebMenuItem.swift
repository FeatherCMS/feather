import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminAddWebMenuItem {
    let controller: any AdminAddWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebMenuItemDefaultInteractor(
                        repository: AdminAddWebMenuItemOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminAddWebMenuItemDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
