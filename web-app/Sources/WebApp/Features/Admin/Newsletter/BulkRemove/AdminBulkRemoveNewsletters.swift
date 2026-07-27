import Hummingbird

struct AdminBulkRemoveNewsletters {
    let controller: any AdminManageNewslettersController

    func route(on router: Router<AppRequestContext>) {
        controller.routeBulkRemove(on: router)
    }
}
