import Hummingbird

struct AdminEditRedirectRule {
    let controller: any AdminEditRedirectRuleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditRedirectRuleDefaultInteractor(
                        repository: AdminEditRedirectRuleOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditRedirectRuleDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
