import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebMenu {
    let controller: any AdminRemoveWebMenuController

    init(
        apiBuilder: API.Builder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveWebMenuDefaultInteractor(
                        repository: AdminRemoveWebMenuOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveWebMenuDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
