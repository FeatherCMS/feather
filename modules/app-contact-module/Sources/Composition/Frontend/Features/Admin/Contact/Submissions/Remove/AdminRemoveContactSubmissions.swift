import FeatherAdmin

struct AdminRemoveContactSubmissions {
    let controller: any AdminRemoveContactSubmissionsController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactSubmissionsDefaultInteractor(
                        repository:
                            AdminRemoveContactSubmissionsOpenAPIRepository(
                                api: context.contactAdminAPI()
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
