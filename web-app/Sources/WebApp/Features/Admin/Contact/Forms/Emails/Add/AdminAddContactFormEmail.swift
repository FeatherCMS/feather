import Hummingbird

struct AdminAddContactFormEmail {
    let controller: any AdminAddContactFormEmailController

    init(details: AdminContactFormDetails) {
        controller = AdminAddContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFormEmailDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminAddContactFormEmailDefaultPresenter(
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
