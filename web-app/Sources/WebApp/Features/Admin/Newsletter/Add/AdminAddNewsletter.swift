import Hummingbird

struct AdminAddNewsletter {
    let controller: any AdminAddContactNewsletterController

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
