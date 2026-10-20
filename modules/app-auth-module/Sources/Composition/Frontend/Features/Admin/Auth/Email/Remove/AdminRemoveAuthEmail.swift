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

struct AdminRemoveAuthEmail {
    let controller: any AdminRemoveAuthEmailController

    init(
        apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveAuthEmailDefaultInteractor(
                        repository: AdminRemoveAuthEmailOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveAuthEmailDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
