import Hummingbird

struct AdminGetNewsletterIssue {
    let controller: any AdminGetNewsletterIssueController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminGetNewsletterIssueDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminGetNewsletterIssueDefaultPresenter(
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
