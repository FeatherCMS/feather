import Hummingbird

struct AdminManageNewsletterSubscribers {
    let controller: any AdminManageNewsletterSubscribersController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminManageNewsletterSubscribersDefaultController { request, context in
            (AdminManageNewsletterSubscribersDefaultInteractor(repository: .init(api: context.managementAPI())), AdminManageNewsletterSubscribersDefaultPresenter(request: request, renderEngine: renderingEngine))
        }
    }
}
