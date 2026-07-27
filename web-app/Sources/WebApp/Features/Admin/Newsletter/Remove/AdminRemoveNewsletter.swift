import Hummingbird

struct AdminRemoveNewsletter {
    let controller: any AdminManageNewslettersController

    func route(on router: Router<AppRequestContext>) {
        controller.routeRemove(on: router)
    }
}
