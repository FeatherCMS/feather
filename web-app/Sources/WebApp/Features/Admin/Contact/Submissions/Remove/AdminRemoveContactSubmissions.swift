import Hummingbird

struct AdminRemoveContactSubmissions {
    let controller: any AdminRemoveContactSubmissionsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactSubmissionsDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminRemoveContactSubmissionsDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
