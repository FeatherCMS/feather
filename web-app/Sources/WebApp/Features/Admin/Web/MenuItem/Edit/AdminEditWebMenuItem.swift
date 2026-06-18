import Hummingbird

struct AdminEditWebMenuItem {
    let controller: any AdminEditWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMenuItemDefaultInteractor(
                        repository: AdminEditWebMenuItemOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditWebMenuItemDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
