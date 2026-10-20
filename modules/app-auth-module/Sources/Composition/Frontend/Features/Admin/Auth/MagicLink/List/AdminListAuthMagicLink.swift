import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminListAuthMagicLink {
    let controller: any AdminListAuthMagicLinkController

    init(
        apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListAuthMagicLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthMagicLinkDefaultInteractor(
                        repository: AdminListAuthMagicLinkOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context)
                        )
                    ),
                    presenter: AdminListAuthMagicLinkDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
