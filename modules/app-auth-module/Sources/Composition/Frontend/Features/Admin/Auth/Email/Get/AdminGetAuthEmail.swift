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
import WebStandards

struct AdminGetAuthEmail {
    let controller: any AdminGetAuthEmailController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAuthEmailDefaultInteractor(
                        repository: AdminGetAuthEmailOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminGetAuthEmailDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
