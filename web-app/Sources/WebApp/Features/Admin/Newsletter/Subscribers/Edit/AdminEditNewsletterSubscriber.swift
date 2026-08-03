import Hummingbird

struct AdminEditNewsletterSubscriber {
    let controller: any AdminEditNewsletterSubscriberController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditNewsletterSubscriberDefaultController {
            request,
            context in
            (
                AdminEditNewsletterSubscriberDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminEditNewsletterSubscriberDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
