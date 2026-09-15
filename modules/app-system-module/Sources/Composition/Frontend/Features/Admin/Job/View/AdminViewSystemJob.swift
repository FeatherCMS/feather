import FeatherAdmin
import Hummingbird

struct AdminViewSystemJob {
    let controller: any AdminViewSystemJobController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminViewSystemJobDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewSystemJobDefaultInteractor(
                        repository: AdminViewSystemJobOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminViewSystemJobDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
