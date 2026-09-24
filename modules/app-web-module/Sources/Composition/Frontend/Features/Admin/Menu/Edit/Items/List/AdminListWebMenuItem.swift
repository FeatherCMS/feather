import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebMenuItem {
    let controller: any AdminListWebMenuItemController

    init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebMenuItemDefaultInteractor(
                        repository: AdminListWebMenuItemOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        )
                    ),
                    presenter: AdminListWebMenuItemDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
