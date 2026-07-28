import Hummingbird

struct AdminGetContactForm {
    let controller: any AdminGetContactFormController

    init(details: AdminContactFormDetails) {
        controller = AdminGetContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetContactFormDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminGetContactFormDefaultPresenter(
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
