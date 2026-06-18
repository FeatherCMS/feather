import Hummingbird

struct AdminListWebMenuItem {
    let controller: any AdminListWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebMenuItemDefaultInteractor(
                        repository: AdminListWebMenuItemOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListWebMenuItemDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
