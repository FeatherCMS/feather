import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetMediaHome {
    let controller: any AdminGetMediaHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetMediaHomeDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetMediaHomeDefaultInteractor(),
                    presenter: AdminGetMediaHomeDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
