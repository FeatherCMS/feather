import Hummingbird

struct AdminListRedirectRule {
    let controller: any AdminListRedirectRuleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListRedirectRuleDefaultInteractor(
                        repository: AdminListRedirectRuleOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminListRedirectRuleDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
