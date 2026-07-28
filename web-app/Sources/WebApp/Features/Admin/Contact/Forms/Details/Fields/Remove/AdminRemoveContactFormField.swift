import Hummingbird

struct AdminRemoveContactFormField {
    let controller: any AdminRemoveContactFormFieldController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactFormFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFormFieldDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminRemoveContactFormFieldDefaultPresenter(
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
