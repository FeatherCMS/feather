import Hummingbird

struct AdminRemoveContactFormItems {
    let controller: any AdminRemoveContactFormItemsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactFormItemsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFormItemsDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminRemoveContactFormItemsDefaultPresenter(
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
