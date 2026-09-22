import FeatherAdmin
import Hummingbird

struct AdminViewRedirectRule {
    let controller: any AdminViewRedirectRuleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewRedirectRuleDefaultInteractor(
                        repository: AdminViewRedirectRuleOpenAPIRepository(
                            api: context.redirectAdminAPI()
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
