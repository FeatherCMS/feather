import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebMenuItem {
    let controller: any AdminListWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebMenuItemDefaultInteractor(
                        repository: AdminListWebMenuItemOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminListWebMenuItemDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
