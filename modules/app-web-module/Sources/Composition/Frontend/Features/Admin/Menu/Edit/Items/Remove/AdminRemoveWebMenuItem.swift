import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebMenuItem {
    let controller: any AdminRemoveWebMenuItemController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveWebMenuItemDefaultInteractor(
                        repository: AdminRemoveWebMenuItemOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveWebMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
