import Hummingbird

struct AdminAddNewsletter {
    let controller: any AdminAddNewsletterCampaignController

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
