import Hummingbird

struct AdminRemoveNewsletterIssue {
    let controller: any AdminRemoveNewsletterIssueController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterIssueDefaultController(
            renderingEngine: renderingEngine
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
