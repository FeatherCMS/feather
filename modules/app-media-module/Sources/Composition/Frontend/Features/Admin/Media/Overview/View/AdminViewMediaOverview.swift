import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewMediaOverview {
    let controller: any AdminViewMediaOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewMediaOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewMediaOverviewDefaultInteractor(),
                    presenter: AdminViewMediaOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
