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

struct AdminEditAuthCredential {
    let controller: any AdminEditAuthCredentialController

    init(apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminEditAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthCredentialDefaultInteractor(
                        repository: AdminEditAuthCredentialOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context),
                            userAPI: apiBuilder.makeUserAdmin(context)
                        )
                    ),
                    presenter: AdminEditAuthCredentialDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
