import Hummingbird

struct AdminAddContactNewsletterIssue {
    let controller: any AdminAddContactNewsletterIssueController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddContactNewsletterIssueDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactNewsletterIssueDefaultInteractor(
                        repository:
                            AdminAddContactNewsletterIssueOpenAPIRepository(
                                api: context.managementAPI()
                            )
                    ),
                    presenter: AdminAddContactNewsletterIssueDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
