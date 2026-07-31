import Hummingbird

struct AdminRemoveNewsletterSubscribers {
    let controller: any AdminRemoveNewsletterSubscribersController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterSubscribersDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterSubscribersDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminRemoveNewsletterSubscribersDefaultPresenter(
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
