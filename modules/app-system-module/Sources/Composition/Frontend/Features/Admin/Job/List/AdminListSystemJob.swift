import FeatherAdmin

struct AdminListSystemJob {
    static let pageSize = 20

    let controller: any AdminListSystemJobController

    init(apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminListSystemJobDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListSystemJobDefaultInteractor(
                        repository: AdminListSystemJobOpenAPIRepository(
                            api: apiBuilder.makeSystemAdmin(context)
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
