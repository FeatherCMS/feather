import FeatherAdmin
import Hummingbird
import UserAdminAPI

struct AdminAddUserRole {
    let controller: any AdminAddUserRoleController

    init(apiBuilder: UserAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminAddUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddUserRoleDefaultInteractor(
                        repository: AdminAddUserRoleOpenAPIRepository(
                            api: apiBuilder.makeUserAdmin(context)
                        )
                    ),
                    presenter: AdminAddUserRoleDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
