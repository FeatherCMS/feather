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

struct AdminAddAuthCredential {
    let controller: any AdminAddAuthCredentialController

    init(
        apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminAddAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAuthCredentialDefaultInteractor(
                        repository: AdminAddAuthCredentialOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context),
                            userAPI: apiBuilder.makeUserAdmin(context)
                        )
                    ),
                    presenter: AdminAddAuthCredentialDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
