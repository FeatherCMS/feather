import FeatherAdmin
import Foundation
import Hummingbird

struct AdminGetRedirectOverview {
    let controller: any AdminGetRedirectOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetRedirectOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetRedirectOverviewDefaultInteractor(),
                    presenter: AdminGetRedirectOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
