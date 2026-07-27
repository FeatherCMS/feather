import Hummingbird

struct AdminGetNewsletterSubscriber {
    let controller: any AdminGetNewsletterSubscriberController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetNewsletterSubscriberDefaultController {
            request,
            context in
            (
                AdminGetNewsletterSubscriberDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminGetNewsletterSubscriberDefaultPresenter(
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
