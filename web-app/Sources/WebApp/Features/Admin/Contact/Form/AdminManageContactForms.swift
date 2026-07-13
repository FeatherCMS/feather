import Hummingbird

struct AdminManageContactForms {
    let renderingEngine: any RenderingEngine
    let controller: any AdminManageContactFormsController

    init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
        self.controller = AdminManageContactFormsDefaultController { request, context in
            (
                AdminManageContactFormsDefaultInteractor(repository: AdminManageContactFormsOpenAPIRepository(api: context.managementAPI())),
                AdminManageContactFormsDefaultPresenter(request: request, renderEngine: renderingEngine)
            )
        }
    }
}
