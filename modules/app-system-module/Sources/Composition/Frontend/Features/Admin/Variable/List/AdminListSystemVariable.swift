import FeatherAdmin
import Hummingbird

struct AdminListSystemVariable {
    static let pageSize = 20

    let controller: any AdminListSystemVariableController

    init(
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListSystemVariableDefaultInteractor(
                        repository: AdminListSystemVariableOpenAPIRepository(
                            api: context.systemAdminAPI()
                        )
                    ),
                    presenter: AdminListSystemVariableDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
