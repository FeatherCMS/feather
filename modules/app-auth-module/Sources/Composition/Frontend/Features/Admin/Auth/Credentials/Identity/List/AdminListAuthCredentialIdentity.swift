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
import WebComponents
import WebBuilders

struct AdminListAuthCredentialIdentity {
    let controller: any AdminListAuthCredentialIdentityController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListAuthCredentialIdentityDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminListAuthCredentialIdentityDefaultInteractor(
                            repository:
                                AdminListAuthCredentialIdentityOpenAPIRepository(
                                    api: context.userAdminAPI()
                                )
                        ),
                    presenter: AdminListAuthCredentialIdentityDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
