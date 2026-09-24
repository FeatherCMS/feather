import FeatherAdmin
import Hummingbird

struct AdminListUserRole {
    static let pageSize = 20

    let controller: any AdminListUserRoleController

    init(
        apiBuilder: UserAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListUserRoleDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListUserRoleDefaultInteractor(
                        repository: AdminListUserRoleOpenAPIRepository(
                            api: apiBuilder.makeUserAdmin(context)
                        )
                    ),
                    presenter: AdminListUserRoleDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
