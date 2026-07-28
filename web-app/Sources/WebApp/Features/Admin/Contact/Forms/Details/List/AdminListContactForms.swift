import Hummingbird

struct AdminListContactForms {
    let controller: any AdminListContactFormsController

    init(details: AdminContactFormDetails) {
        controller = AdminListContactFormsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormsDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminListContactFormsDefaultPresenter(
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
