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

struct AdminEditAuthMagicLink {
    let controller: any AdminEditAuthMagicLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthMagicLinkDefaultInteractor(
                        repository: AdminEditAuthMagicLinkOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminEditAuthMagicLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
