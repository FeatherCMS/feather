import Hummingbird

struct AdminRemoveContactForm {
    let controller: any AdminRemoveContactFormController

    init(details: AdminContactFormDetails) {
        controller = AdminRemoveContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFormDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminRemoveContactFormDefaultPresenter(
                        request: request,
                        renderEngine: details.renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
