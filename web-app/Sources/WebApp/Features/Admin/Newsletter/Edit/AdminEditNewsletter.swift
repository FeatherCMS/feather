import Hummingbird

struct AdminEditNewsletter {
    let controller: any AdminManageNewslettersController

    func route(on router: Router<AppRequestContext>) {
        controller.routeEdit(on: router)
    }
}
