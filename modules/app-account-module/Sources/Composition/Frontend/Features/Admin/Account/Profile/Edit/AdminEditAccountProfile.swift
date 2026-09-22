import FeatherAdmin
import MediaFrontend

struct AdminEditAccountProfile {
    let controller: any AdminEditAccountProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAccountProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAccountProfileDefaultInteractor(
                        accountProfileRepository:
                            AdminEditAccountProfileOpenAPIRepository(
                                api: context.accountAppAPI(),
                                mediaAPI: context.mediaAdminAPI()
                            )
                    ),
                    presenter: AdminEditAccountProfileDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
