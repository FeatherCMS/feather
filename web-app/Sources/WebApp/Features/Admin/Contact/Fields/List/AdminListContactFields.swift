import Hummingbird

struct AdminListContactFields {
    let controller: any AdminListContactFieldsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListContactFieldsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFieldsDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminListContactFieldsDefaultPresenter(
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
