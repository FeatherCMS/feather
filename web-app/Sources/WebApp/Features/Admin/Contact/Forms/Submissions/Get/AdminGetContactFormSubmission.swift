import Hummingbird

struct AdminGetContactFormSubmission {
    let controller: any AdminGetContactFormSubmissionController

    init(submissions: AdminContactFormSubmissions) {
        controller = AdminGetContactFormSubmissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetContactFormSubmissionDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminGetContactFormSubmissionDefaultPresenter(
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
