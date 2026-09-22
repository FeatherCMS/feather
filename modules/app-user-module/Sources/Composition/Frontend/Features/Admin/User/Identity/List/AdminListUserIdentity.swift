import FeatherAdmin

struct AdminListUserIdentity {
    static let pageSize = 20

    let controller: any AdminListUserIdentityController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListUserIdentityDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListUserIdentityDefaultInteractor(
                        repository: AdminListUserIdentityOpenAPIRepository(
                            api: context.userAdminAPI()
                        )
                    ),
                    presenter: AdminListUserIdentityDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
