import FeatherAdmin
import Hummingbird

struct AdminEditSettings {
    let controller: any AdminEditSettingsController

    init(
        apiBuilder: AccountAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditSettingsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditSettingsDefaultInteractor(
                        repository: AdminEditSettingsOpenAPIRepository(
                            api: apiBuilder.makeAccountAdmin(context),
                            targetUserID: context.parameters.get(
                                "userId",
                                as: String.self
                            )
                        )
                    ),
                    presenter: AdminEditSettingsDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
