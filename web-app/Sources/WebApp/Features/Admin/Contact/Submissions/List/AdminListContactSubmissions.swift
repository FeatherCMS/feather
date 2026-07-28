import Hummingbird

struct AdminListContactSubmissions {
    let controller: any AdminListContactSubmissionsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListContactSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactSubmissionsDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminListContactSubmissionsDefaultPresenter(
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
