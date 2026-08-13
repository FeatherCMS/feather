import FeatherAdmin
import Hummingbird

struct AdminListSystemJob {
    let controller: any AdminListSystemJobController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListSystemJobDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListSystemJobDefaultInteractor(
                        repository: AdminListSystemJobOpenAPIRepository(
                            api: context.systemManagementAPI()
                        )
                    ),
                    presenter: AdminListSystemJobDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
