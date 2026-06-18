import Hummingbird

struct AdminEditAuthSettings {
    let controller: any AdminEditAuthSettingsController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAuthSettingsDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminEditAuthSettingsDefaultInteractor(),
                    presenter: AdminEditAuthSettingsDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
