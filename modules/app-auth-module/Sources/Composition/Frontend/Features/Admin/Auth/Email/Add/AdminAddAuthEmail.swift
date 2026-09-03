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

struct AdminAddAuthEmail {
    let controller: any AdminAddAuthEmailController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAuthEmailDefaultInteractor(
                        repository: AdminAddAuthEmailOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminAddAuthEmailDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
