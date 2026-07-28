import Hummingbird

struct AdminEditContactFormItems {
    let controller: any AdminEditContactFormItemsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFormItemsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormItemsDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminEditContactFormItemsDefaultPresenter(
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
