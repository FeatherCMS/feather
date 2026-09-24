import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebMenu {
    let controller: any AdminViewWebMenuController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebMenuDefaultInteractor(
                        repository: AdminViewWebMenuOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
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
