import FeatherAdmin
import Foundation
import Hummingbird

struct AdminGetRedirectRule {
    let controller: any AdminGetRedirectRuleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetRedirectRuleDefaultInteractor(
                        repository: AdminGetRedirectRuleOpenAPIRepository(
                            api: context.redirectAdminAPI()
                        )
                    ),
                    presenter: AdminGetRedirectRuleDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
