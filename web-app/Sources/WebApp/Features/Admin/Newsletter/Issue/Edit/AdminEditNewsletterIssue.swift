import Hummingbird

struct AdminEditNewsletterIssue {
    let controller: any AdminEditNewsletterIssueController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditNewsletterIssueDefaultController(
            renderingEngine: renderingEngine
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
