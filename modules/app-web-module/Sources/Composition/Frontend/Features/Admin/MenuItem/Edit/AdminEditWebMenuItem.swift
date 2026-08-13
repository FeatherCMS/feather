import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminEditWebMenuItem {
    let controller: any AdminEditWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMenuItemDefaultInteractor(
                        repository: AdminEditWebMenuItemOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminEditWebMenuItemDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
