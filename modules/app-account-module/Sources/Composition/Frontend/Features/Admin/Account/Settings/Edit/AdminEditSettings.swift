import FeatherAdmin
import Hummingbird

struct AdminEditSettings {
    let controller: any AdminEditSettingsController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditSettingsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditSettingsDefaultInteractor(
                        repository: AdminEditSettingsOpenAPIRepository(
                            api: context.accountAdminAPI(),
                            targetUserID: AdminEditSettingsOpenAPIRepository
                                .targetUserID(for: request)
                        )
                    ),
                    presenter: AdminEditSettingsDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
