import FeatherAdmin

struct AdminViewSystemJob {
    let controller: any AdminViewSystemJobController

    init(apiBuilder: SystemAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminViewSystemJobDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewSystemJobDefaultInteractor(
                        repository: AdminViewSystemJobOpenAPIRepository(
                            api: apiBuilder.makeSystemAdmin(context)
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
