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

struct AdminRemoveAuthMagicLink {
    let controller: any AdminRemoveAuthMagicLinkController

    init(
        apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
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
