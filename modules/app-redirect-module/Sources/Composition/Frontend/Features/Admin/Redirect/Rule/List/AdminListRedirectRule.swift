import FeatherAdmin

struct AdminListRedirectRule {
    static let pageSize = 20

    let controller: any AdminListRedirectRuleController

    init(apiBuilder: RedirectAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminListRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListRedirectRuleDefaultInteractor(
                        repository: AdminListRedirectRuleOpenAPIRepository(
                            api: apiBuilder.makeRedirectAdmin(context)
                        )
                    ),
                    presenter: AdminListRedirectRuleDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
