import FeatherAdmin
import Hummingbird

struct AdminEditUserRole {
    let controller: any AdminEditUserRoleController

    init(apiBuilder: UserAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminEditUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditUserRoleDefaultInteractor(
                        repository: AdminEditUserRoleOpenAPIRepository(
                            api: apiBuilder.makeUserAdmin(context)
                        )
                    ),
                    presenter: AdminEditUserRoleDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
