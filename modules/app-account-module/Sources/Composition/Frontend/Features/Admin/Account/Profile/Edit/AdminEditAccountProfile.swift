import FeatherAdmin
import MediaFrontend

struct AdminEditAccountProfile {
    let controller: any AdminEditAccountProfileController

    init(
        apiBuilder: AccountAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditAccountProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAccountProfileDefaultInteractor(
                        accountProfileRepository:
                            AdminEditAccountProfileOpenAPIRepository(
                                api: apiBuilder.makeAccountApp(context),
                                mediaAPI: apiBuilder.makeMediaAdmin(context)
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
