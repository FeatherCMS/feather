import FeatherAdmin
import Foundation
import Hummingbird

struct AdminRemoveRedirectRule {
    let controller: any AdminRemoveRedirectRuleController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveRedirectRuleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveRedirectRuleDefaultInteractor(
                        repository: AdminRemoveRedirectRuleOpenAPIRepository(
                            api: context.redirectAdminAPI()
                        )
                    ),
                    presenter: AdminRemoveRedirectRuleDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
