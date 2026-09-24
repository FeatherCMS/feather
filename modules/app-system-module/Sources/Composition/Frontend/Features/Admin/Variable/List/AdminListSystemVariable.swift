import FeatherAdmin
import Hummingbird

struct AdminListSystemVariable {
    static let pageSize = 20

    let controller: any AdminListSystemVariableController

    init(
        apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListSystemVariableDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListSystemVariableDefaultInteractor(
                        repository: AdminListSystemVariableOpenAPIRepository(
                            api: apiBuilder.makeSystemAdmin(context)
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
