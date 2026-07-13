import Hummingbird

struct AdminNewsletter {
    let renderingEngine: any RenderingEngine

    func route(on router: Router<AppRequestContext>) {
        AdminManageNewsletters(renderingEngine: renderingEngine).controller.route(on: router)
        AdminNewsletterIssueList(renderingEngine: renderingEngine).controller.route(on: router)
        AdminManageNewsletterSubscribers(renderingEngine: renderingEngine).controller.route(on: router)
        AdminNewsletterSubscribersDirectory(renderingEngine: renderingEngine).controller.route(on: router)
        AdminAddNewsletterSubscriber(renderingEngine: renderingEngine).controller.route(on: router)
        AdminAddContactNewsletter(renderingEngine: renderingEngine).controller.route(on: router)
        AdminAddContactNewsletterIssue(renderingEngine: renderingEngine).controller.route(on: router)
    }
}
