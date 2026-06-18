import Hummingbird

struct AdminAddRedirectRule {
    let controller: any AdminAddRedirectRuleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddRedirectRuleDefaultInteractor(
                        repository: AdminAddRedirectRuleOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddRedirectRuleDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
