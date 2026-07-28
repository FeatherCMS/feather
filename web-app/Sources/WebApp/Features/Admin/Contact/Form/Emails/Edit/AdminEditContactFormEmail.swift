import Hummingbird

struct AdminEditContactFormEmail {
    let controller: any AdminEditContactFormEmailController

    init(details: AdminContactFormDetails) {
        controller = AdminEditContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormEmailDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminEditContactFormEmailDefaultPresenter(
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
