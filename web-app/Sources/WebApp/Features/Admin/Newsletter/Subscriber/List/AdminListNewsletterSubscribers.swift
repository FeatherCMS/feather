import Hummingbird

struct AdminListNewsletterSubscribers {
    let controller: any AdminManageNewsletterSubscribersController

    func route(on router: Router<AppRequestContext>) {
        controller.routeList(on: router)
    }
}
