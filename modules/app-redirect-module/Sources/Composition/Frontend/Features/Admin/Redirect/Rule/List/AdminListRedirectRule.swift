import FeatherAdmin
import Hummingbird

struct AdminListRedirectRule {
    static let pageSize = 20

    let controller: any AdminListRedirectRuleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListRedirectRuleDefaultInteractor(
                        repository: AdminListRedirectRuleOpenAPIRepository(
                            api: context.redirectAdminAPI()
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
