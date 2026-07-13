import Hummingbird

struct AdminManageContactFormItems {
    let controller: any AdminManageContactFormItemsController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminManageContactFormItemsDefaultController { request, context in
            (AdminManageContactFormItemsDefaultInteractor(repository: .init(api: context.managementAPI())), AdminManageContactFormItemsDefaultPresenter(request: request, renderEngine: renderingEngine))
        }
    }
}
