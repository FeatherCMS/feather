import Hummingbird

struct AdminListContactFormSubmissions {
    let controller: any AdminListContactFormSubmissionsController

    init(submissions: AdminContactFormSubmissions) {
        controller = AdminListContactFormSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminListContactFormSubmissionsDefaultInteractor(
                            repository: .init(api: context.managementAPI())
                        ),
                    presenter: AdminListContactFormSubmissionsDefaultPresenter(
                        request: request,
                        renderEngine: submissions.renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
