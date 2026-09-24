import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminEditWebMenu {
    let controller: any AdminEditWebMenuController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMenuDefaultInteractor(
                        repository: AdminEditWebMenuOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        )
                    ),
                    presenter: AdminEditWebMenuDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
