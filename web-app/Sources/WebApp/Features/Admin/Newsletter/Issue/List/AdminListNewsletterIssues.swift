import Hummingbird

struct AdminListNewsletterIssues {
    let controller: any AdminNewsletterIssueListController

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
