struct AdminAddNewsletterSubscriber {
    let controller: any AdminAddNewsletterSubscriberController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterSubscriberDefaultController { request, context in
            (
                AdminAddNewsletterSubscriberDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminAddNewsletterSubscriberDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }
}
