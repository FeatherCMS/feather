import FeatherAdmin
import Hummingbird

struct AdminNewsCategories: Sendable {
    let apiBuilder: NewsAPIBuilder
    let renderingEngine: any RenderingEngine

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        let buildRuntime: AdminNewsCategoryRuntimeBuilder = {
            request,
            context in
            let api = apiBuilder.makeNewsAdmin(context)
            return AdminNewsCategoryRuntime(
                interactor: AdminNewsCategoryDefaultInteractor(
                    repository: AdminNewsCategoryOpenAPIRepository(
                        api: api
                    )
                ),
                presenter: AdminNewsCategoryDefaultPresenter(
                    request: request,
                    context: context,
                    mediaAPI: api.mediaAdminAPI(),
                    renderingEngine: renderingEngine
                )
            )
        }
        AdminListNewsCategoryDefaultController(buildRuntime: buildRuntime)
            .route(on: router)
        AdminAddNewsCategoryDefaultController(buildRuntime: buildRuntime)
            .route(on: router)
        AdminViewNewsCategoryDefaultController(buildRuntime: buildRuntime)
            .route(on: router)
        AdminEditNewsCategoryDefaultController(buildRuntime: buildRuntime)
            .route(on: router)
        AdminRemoveNewsCategoryDefaultController(buildRuntime: buildRuntime)
            .route(on: router)
    }
}
