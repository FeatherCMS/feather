import Hummingbird

struct AdminListContactFormEmails {
    let controller: any AdminListContactFormEmailsController

    init(details: AdminContactFormDetails) {
        controller = AdminListContactFormEmailsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormEmailsDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminListContactFormEmailsDefaultPresenter(
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
