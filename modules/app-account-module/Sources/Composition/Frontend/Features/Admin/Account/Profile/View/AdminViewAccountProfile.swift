import FeatherAdmin
import MediaFrontend

struct AdminViewAccountProfile {
    let controller: any AdminViewAccountProfileController

    init(apiBuilder: AccountAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAccountProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAccountProfileDefaultInteractor(
                        accountProfileRepository:
                            AdminViewAccountProfileOpenAPIRepository(
                                api: apiBuilder.makeAccountApp(context),
                                mediaAPI: apiBuilder.makeMediaAdmin(context)
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
