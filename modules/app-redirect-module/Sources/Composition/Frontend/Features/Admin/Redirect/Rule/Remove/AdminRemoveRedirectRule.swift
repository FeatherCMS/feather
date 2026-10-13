import FeatherAdmin

struct AdminRemoveRedirectRule {
    let controller: any AdminRemoveRedirectRuleController

    init(
        apiBuilder: RedirectAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveRedirectRuleDefaultInteractor(
                        repository: AdminRemoveRedirectRuleOpenAPIRepository(
                            api: apiBuilder.makeRedirectAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveRedirectRuleDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
