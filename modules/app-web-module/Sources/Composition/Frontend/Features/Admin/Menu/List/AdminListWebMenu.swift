import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebMenu {
    let controller: any AdminListWebMenuController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebMenuDefaultInteractor(
                        repository: AdminListWebMenuOpenAPIRepository(
                            api: context.webAdminAPI()
                        )
                    ),
                    presenter: AdminListWebMenuDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
