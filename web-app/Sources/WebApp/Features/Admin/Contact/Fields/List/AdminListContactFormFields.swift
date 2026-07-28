import Hummingbird

struct AdminListContactFormFields {
    let controller: any AdminListContactFormFieldsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListContactFormFieldsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormFieldsDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminListContactFormFieldsDefaultPresenter(
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

    func routeCatalog(on router: Router<AppRequestContext>) {
        controller.routeCatalog(on: router)
    }
}
