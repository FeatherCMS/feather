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

struct AdminRemoveAuthCredential {
    let controller: any AdminRemoveAuthCredentialController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveAuthCredentialDefaultInteractor(
                        repository: AdminRemoveAuthCredentialOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminRemoveAuthCredentialDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
