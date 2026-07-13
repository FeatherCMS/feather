import Hummingbird

struct AdminManageNewsletters {
    let renderingEngine: any RenderingEngine
    let controller: any AdminManageNewslettersController

    init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
        self.controller = AdminManageNewslettersDefaultController { request, context in
            (
                AdminManageNewslettersDefaultInteractor(repository: AdminManageNewslettersOpenAPIRepository(api: context.managementAPI())),
                AdminManageNewslettersDefaultPresenter(request: request, renderEngine: renderingEngine)
            )
        }
    }
}
