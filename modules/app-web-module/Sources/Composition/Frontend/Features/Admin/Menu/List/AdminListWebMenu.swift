import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebMenu {
    let controller: any AdminListWebMenuController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebMenuDefaultInteractor(
                        repository: AdminListWebMenuOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        )
                    ),
                    presenter: AdminListWebMenuDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
