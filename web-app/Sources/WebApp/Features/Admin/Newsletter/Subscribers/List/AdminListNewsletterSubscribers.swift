import Hummingbird

struct AdminListNewsletterSubscribers {
    let controller: any AdminListNewsletterSubscribersController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListNewsletterSubscribersDefaultController {
            request,
            context in
            (
                AdminListNewsletterSubscribersDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminListNewsletterSubscribersDefaultPresenter(
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
