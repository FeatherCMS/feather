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

struct AdminAddAuthCredential {
    let controller: any AdminAddAuthCredentialController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAuthCredentialDefaultInteractor(
                        repository: AdminAddAuthCredentialOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminAddAuthCredentialDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
