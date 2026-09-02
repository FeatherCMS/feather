import FeatherAdmin
import Hummingbird

struct AdminGetSystemJob {
    let controller: any AdminGetSystemJobController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetSystemJobDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetSystemJobDefaultInteractor(
                        repository: AdminGetSystemJobOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminGetSystemJobDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
