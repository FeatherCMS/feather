import Hummingbird

struct AdminEditNewsletterIssue {
    let controller: any AdminEditNewsletterIssueController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminEditNewsletterIssueDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminEditNewsletterIssueDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
