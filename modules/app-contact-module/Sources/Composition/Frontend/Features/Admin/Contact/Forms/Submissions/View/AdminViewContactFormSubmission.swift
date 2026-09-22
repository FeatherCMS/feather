import FeatherAdmin

struct AdminViewContactFormSubmission {
    let controller: any AdminViewContactFormSubmissionController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminViewContactFormSubmissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewContactFormSubmissionDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
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
