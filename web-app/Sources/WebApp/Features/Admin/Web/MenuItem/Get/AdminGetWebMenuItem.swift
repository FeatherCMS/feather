import Hummingbird

struct AdminGetWebMenuItem {
    let controller: any AdminGetWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetWebMenuItemDefaultInteractor(
                        repository: AdminGetWebMenuItemOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetWebMenuItemDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
