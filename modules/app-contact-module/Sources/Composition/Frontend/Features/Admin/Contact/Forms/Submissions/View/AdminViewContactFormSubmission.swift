import FeatherAdmin

struct AdminViewContactFormSubmission {
    let controller: any AdminViewContactFormSubmissionController

    init(apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminViewContactFormSubmissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewContactFormSubmissionDefaultInteractor(
                        repository: .init(api: apiBuilder.makeContactAdmin(context))
                    ),
                    presenter: AdminViewContactFormSubmissionDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
