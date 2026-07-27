import Hummingbird

struct AdminRemoveNewsletterIssue {
    let controller: any AdminRemoveNewsletterIssueController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterIssueDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminRemoveNewsletterIssueDefaultPresenter(
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
