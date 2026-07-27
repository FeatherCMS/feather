import Hummingbird

struct AdminAddNewsletterCampaignSubscriber {
    let controller: any AdminManageNewsletterSubscribersController

    func route(on router: Router<AppRequestContext>) {
        controller.routeAdd(on: router)
    }
}
