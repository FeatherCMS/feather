import FeatherAdmin
import Hummingbird

struct AdminListSystemJob {
    static let pageSize = 20

    let controller: any AdminListSystemJobController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListSystemJobDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListSystemJobDefaultInteractor(
                        repository: AdminListSystemJobOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminListSystemJobDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
