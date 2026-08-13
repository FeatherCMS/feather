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

struct AdminAddAuthMagicLink {
    let controller: any AdminAddAuthMagicLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAuthMagicLinkDefaultInteractor(
                        repository: AdminAddAuthMagicLinkOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminAddAuthMagicLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
