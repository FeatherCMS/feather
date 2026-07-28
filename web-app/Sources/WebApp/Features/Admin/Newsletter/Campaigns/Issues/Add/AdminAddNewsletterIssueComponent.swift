import Hummingbird

struct AdminAddNewsletterIssueComponent {
    let controller: any AdminAddNewsletterIssueController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterIssueDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddNewsletterIssueDefaultInteractor(
                        repository:
                            AdminAddNewsletterIssueOpenAPIRepository(
                                api: context.managementAPI()
                            )
                    ),
                    presenter: AdminAddNewsletterIssueDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
