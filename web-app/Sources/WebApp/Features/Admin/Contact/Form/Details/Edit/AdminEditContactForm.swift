import Hummingbird

struct AdminEditContactForm {
    let controller: any AdminEditContactFormController

    init(details: AdminContactFormDetails) {
        controller = AdminEditContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminEditContactFormDefaultPresenter(
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
