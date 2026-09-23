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

struct AdminViewAuthMagicLink {
    let controller: any AdminViewAuthMagicLinkController

    init(apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAuthMagicLinkDefaultInteractor(
                        repository: AdminViewAuthMagicLinkOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context)
                        )
                    ),
                    presenter: AdminViewAuthMagicLinkDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
