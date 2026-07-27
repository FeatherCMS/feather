import Hummingbird

struct AdminRemoveNewsletterCampaignSubscriber {
    let controller: any AdminManageNewsletterSubscribersController

    func route(on router: Router<AppRequestContext>) {
        controller.routeRemove(on: router)
    }
}
