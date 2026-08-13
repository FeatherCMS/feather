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

struct AdminListAuthCredential {
    let controller: any AdminListAuthCredentialController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthCredentialDefaultInteractor(
                        repository: AdminListAuthCredentialOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminListAuthCredentialDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
