import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminAddWebMenu {
    let controller: any AdminAddWebMenuController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebMenuDefaultInteractor(
                        repository: AdminAddWebMenuOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        )
                    ),
                    presenter: AdminAddWebMenuDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
