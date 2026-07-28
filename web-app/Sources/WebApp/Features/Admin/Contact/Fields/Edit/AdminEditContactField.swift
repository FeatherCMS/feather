import Hummingbird

struct AdminEditContactField {
    let controller: any AdminEditContactFieldController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFieldDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminEditContactFieldDefaultPresenter(
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
