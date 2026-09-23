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

struct AdminListAuthCredential {
    let controller: any AdminListAuthCredentialController

    init(apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminListAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthCredentialDefaultInteractor(
                        repository: AdminListAuthCredentialOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context)
                        )
                    ),
                    presenter: AdminListAuthCredentialDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
