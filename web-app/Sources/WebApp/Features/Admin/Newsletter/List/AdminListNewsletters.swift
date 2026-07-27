import Hummingbird

struct AdminListNewsletters {
    let controller: any AdminManageNewslettersController

    func route(on router: Router<AppRequestContext>) {
        controller.routeList(on: router)
    }
}
