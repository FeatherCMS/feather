import FeatherAdmin

struct AdminEditRedirectRule {
    let controller: any AdminEditRedirectRuleController

    init(apiBuilder: RedirectAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminEditRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditRedirectRuleDefaultInteractor(
                        repository: AdminEditRedirectRuleOpenAPIRepository(
                            api: apiBuilder.makeRedirectAdmin(context)
                        )
                    ),
                    presenter: AdminEditRedirectRuleDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
