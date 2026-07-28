import Hummingbird

struct AdminRemoveContactFormEmail {
    let controller: any AdminRemoveContactFormEmailController

    init(details: AdminContactFormDetails) {
        controller = AdminRemoveContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFormEmailDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminRemoveContactFormEmailDefaultPresenter(
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
