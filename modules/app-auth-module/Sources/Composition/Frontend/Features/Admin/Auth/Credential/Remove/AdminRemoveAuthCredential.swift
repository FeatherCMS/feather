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

struct AdminRemoveAuthCredential {
    let controller: any AdminRemoveAuthCredentialController

    init(
        apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminRemoveAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveAuthCredentialDefaultInteractor(
                        repository: AdminRemoveAuthCredentialOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveAuthCredentialDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
