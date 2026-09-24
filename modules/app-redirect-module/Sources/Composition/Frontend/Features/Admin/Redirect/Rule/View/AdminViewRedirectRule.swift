import FeatherAdmin

struct AdminViewRedirectRule {
    let controller: any AdminViewRedirectRuleController

    init(
        apiBuilder: RedirectAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewRedirectRuleDefaultInteractor(
                        repository: AdminViewRedirectRuleOpenAPIRepository(
                            api: apiBuilder.makeRedirectAdmin(context)
                        )
                    ),
                    presenter: AdminViewRedirectRuleDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
