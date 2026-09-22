import FeatherAdmin
import MediaFrontend

struct AdminViewAccountProfile {
    let controller: any AdminViewAccountProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAccountProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAccountProfileDefaultInteractor(
                        accountProfileRepository:
                            AdminViewAccountProfileOpenAPIRepository(
                                api: context.accountAppAPI(),
                                mediaAPI: context.mediaAdminAPI()
                            )
                    ),
                    presenter: AdminViewAccountProfileDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
