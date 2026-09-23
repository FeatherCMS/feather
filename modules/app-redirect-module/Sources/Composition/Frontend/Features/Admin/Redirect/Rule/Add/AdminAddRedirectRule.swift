import FeatherAdmin

struct AdminAddRedirectRule {
    let controller: any AdminAddRedirectRuleController

    init(apiBuilder: RedirectAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminAddRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddRedirectRuleDefaultInteractor(
                        repository: AdminAddRedirectRuleOpenAPIRepository(
                            api: apiBuilder.makeRedirectAdmin(context)
                        )
                    ),
                    presenter: AdminAddRedirectRuleDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
