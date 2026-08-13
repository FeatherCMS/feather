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

struct AdminGetAuthMagicLink {
    let controller: any AdminGetAuthMagicLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAuthMagicLinkDefaultInteractor(
                        repository: AdminGetAuthMagicLinkOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminGetAuthMagicLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
