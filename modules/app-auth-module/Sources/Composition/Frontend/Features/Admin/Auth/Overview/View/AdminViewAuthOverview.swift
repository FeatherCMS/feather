import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminViewAuthOverview {
    let controller: any AdminViewAuthOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAuthOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAuthOverviewDefaultInteractor(),
                    presenter: AdminViewAuthOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
