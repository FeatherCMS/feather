import FeatherAdmin
import Hummingbird
import MediaContracts

struct AdminListMediaVariantDefaultController: AdminListMediaVariantController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListMediaVariantInteractor,
            any AdminListMediaVariantPresenter
        >

    func getMediaVariants(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: MediaPermissions.Variants.list)
        else {
            return try await presenter.renderErrorPage(error: .forbidden)
        }
        do {
            return try await presenter.renderListPage(
                model: try await interactor.listMediaVariants(
                    page: request.queryPage(),
                    search: request.querySearch()
                ),
                permissions: context.currentUserAdminListActions,
                search: request.querySearch()
            )
        }
        catch let error as AdminListMediaVariantError {
            return try await presenter.renderErrorPage(error: error)
        }
    }
}
