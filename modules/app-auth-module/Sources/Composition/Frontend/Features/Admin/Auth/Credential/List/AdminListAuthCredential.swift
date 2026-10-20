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

struct AdminListAuthCredential {
    let controller: any AdminListAuthCredentialController

    init(
        apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
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
