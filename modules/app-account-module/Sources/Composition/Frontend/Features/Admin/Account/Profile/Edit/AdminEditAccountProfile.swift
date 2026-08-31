import FeatherAdmin
import Hummingbird

struct AdminEditAccountProfile {
    let controller: any AdminEditAccountProfileController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditAccountProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAccountProfileDefaultInteractor(
                        repository: AdminEditAccountProfileOpenAPIRepository(
                            api: context.accountAdminAPI()
                        )
                    ),
                    presenter: AdminEditAccountProfileDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
