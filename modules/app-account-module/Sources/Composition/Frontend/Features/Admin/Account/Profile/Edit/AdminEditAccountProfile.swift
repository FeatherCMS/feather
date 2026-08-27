import FeatherAdmin
import Hummingbird

struct AdminEditAccountProfile {
    let controller: any AdminEditAccountProfileController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditAccountProfileDefaultController(
            buildRuntime: { request, context in
                (
                    repository: AdminEditAccountProfileOpenAPIRepository(
                        api: context.accountAdminAPI()
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
