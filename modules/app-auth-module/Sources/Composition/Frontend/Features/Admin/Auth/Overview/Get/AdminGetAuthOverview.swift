import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminGetAuthOverview {
    let controller: any AdminGetAuthOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAuthOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAuthOverviewDefaultInteractor(),
                    presenter: AdminGetAuthOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
