import FeatherAdmin

struct AdminRemoveContactSubmissions {
    let controller: any AdminRemoveContactSubmissionsController
    init(apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactSubmissionsDefaultInteractor(
                        repository:
                            AdminRemoveContactSubmissionsOpenAPIRepository(
                                api: apiBuilder.makeContactAdmin(context)
                            )
                    ),
                    presenter: AdminRemoveContactSubmissionsDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
