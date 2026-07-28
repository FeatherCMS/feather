import Hummingbird

struct AdminRemoveContactFormSubmissions {
    let controller: any AdminRemoveContactFormSubmissionsController

    init(submissions: AdminContactFormSubmissions) {
        controller = AdminRemoveContactFormSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminRemoveContactFormSubmissionsDefaultInteractor(
                            repository: .init(api: context.managementAPI())
                        ),
                    presenter:
                        AdminRemoveContactFormSubmissionsDefaultPresenter(
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
