import Hummingbird

struct AdminEditNewsletterCampaignSubscriber {
    let controller: any AdminManageNewsletterSubscribersController

    func route(on router: Router<AppRequestContext>) {
        controller.routeEdit(on: router)
    }
}
