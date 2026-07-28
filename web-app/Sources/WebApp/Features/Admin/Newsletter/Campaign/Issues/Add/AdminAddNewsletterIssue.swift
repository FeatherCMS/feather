import Hummingbird

struct AdminAddNewsletterIssue {
    let controller: any AdminAddNewsletterIssueController

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
