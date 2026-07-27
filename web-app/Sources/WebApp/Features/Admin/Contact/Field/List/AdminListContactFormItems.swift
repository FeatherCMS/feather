import Hummingbird

struct AdminListContactFormItems {
    let controller: any AdminListContactFormItemsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListContactFormItemsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormItemsDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminListContactFormItemsDefaultPresenter(
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
