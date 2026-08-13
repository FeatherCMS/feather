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

struct AdminListAuthMagicLink {
    let controller: any AdminListAuthMagicLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthMagicLinkDefaultInteractor(
                        repository: AdminListAuthMagicLinkOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminListAuthMagicLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
