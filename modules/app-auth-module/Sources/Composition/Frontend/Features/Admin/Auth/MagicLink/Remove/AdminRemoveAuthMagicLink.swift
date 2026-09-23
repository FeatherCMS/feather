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

struct AdminRemoveAuthMagicLink {
    let controller: any AdminRemoveAuthMagicLinkController

    init(apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveAuthMagicLinkDefaultInteractor(
                        repository: AdminRemoveAuthMagicLinkOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveAuthMagicLinkDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
