import Hummingbird

struct AdminBulkRemoveNewsletterSubscribers {
    let controller: any AdminManageNewsletterSubscribersController

    func route(on router: Router<AppRequestContext>) {
        controller.routeBulkRemove(on: router)
    }
}
