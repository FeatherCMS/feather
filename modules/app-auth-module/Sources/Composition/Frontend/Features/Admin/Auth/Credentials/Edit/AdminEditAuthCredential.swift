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
import WebStandards

struct AdminEditAuthCredential {
    let controller: any AdminEditAuthCredentialController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthCredentialDefaultInteractor(
                        repository: AdminEditAuthCredentialOpenAPIRepository(
                            api: context.authAdminAPI(),
                            userAPI: context.userAdminAPI()
                        )
                    ),
                    presenter: AdminEditAuthCredentialDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
