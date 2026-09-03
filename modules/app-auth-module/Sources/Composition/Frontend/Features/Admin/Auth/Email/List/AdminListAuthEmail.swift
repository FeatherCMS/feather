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

struct AdminListAuthEmail {
    let controller: any AdminListAuthEmailController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthEmailDefaultInteractor(
                        repository: AdminListAuthEmailOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminListAuthEmailDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
