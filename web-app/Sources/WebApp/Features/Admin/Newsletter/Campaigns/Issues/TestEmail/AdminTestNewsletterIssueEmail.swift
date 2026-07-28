import Hummingbird

struct AdminTestNewsletterIssueEmail {
    let controller: any AdminTestNewsletterIssueEmailController

    init() {
        controller = AdminTestNewsletterIssueEmailDefaultController()
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
