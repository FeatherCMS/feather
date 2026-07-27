import Hummingbird

struct AdminAddNewsletterIssue {
    let controller: any AdminAddContactNewsletterIssueController

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
