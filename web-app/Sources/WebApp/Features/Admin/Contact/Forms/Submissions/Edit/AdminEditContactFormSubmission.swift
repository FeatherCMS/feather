import Hummingbird

struct AdminEditContactFormSubmission {
    let controller: any AdminEditContactFormSubmissionController

    init(submissions: AdminContactFormSubmissions) {
        controller = AdminEditContactFormSubmissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormSubmissionDefaultInteractor(
                        repository: .init(api: context.managementAPI())
                    ),
                    presenter: AdminEditContactFormSubmissionDefaultPresenter(
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
