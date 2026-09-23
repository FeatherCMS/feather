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

struct AdminAddAuthMagicLink {
    let controller: any AdminAddAuthMagicLinkController

    init(apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminAddAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAuthMagicLinkDefaultInteractor(
                        repository: AdminAddAuthMagicLinkOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context)
                        )
                    ),
                    presenter: AdminAddAuthMagicLinkDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
