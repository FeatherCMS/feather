import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebMenu {
    let controller: any AdminRemoveWebMenuController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveWebMenuDefaultInteractor(
                        repository: AdminRemoveWebMenuOpenAPIRepository(
                            api: context.webAdminAPI()
                        )
                    ),
                    presenter: AdminRemoveWebMenuDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
