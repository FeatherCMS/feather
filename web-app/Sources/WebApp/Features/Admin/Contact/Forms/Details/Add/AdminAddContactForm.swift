import Hummingbird

struct AdminAddContactForm {
    let controller: any AdminAddContactFormController

    init(details: AdminContactFormDetails) {
        controller = AdminAddContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFormDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminAddContactFormDefaultPresenter(
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
