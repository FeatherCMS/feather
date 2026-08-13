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

struct AdminRemoveAuthMagicLink {
    let controller: any AdminRemoveAuthMagicLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveAuthMagicLinkDefaultInteractor(
                        repository: AdminRemoveAuthMagicLinkOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminRemoveAuthMagicLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
