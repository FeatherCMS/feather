import FeatherAdmin
import Hummingbird
import MediaContracts

struct AdminListMediaVariantProcessorsDefaultController:
    AdminListMediaVariantProcessorsController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListMediaVariantProcessorsInteractor,
            any AdminListMediaVariantProcessorsPresenter
        >

    func getMediaVariantProcessors(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(
                to: MediaPermissions.VariantProcessors.list
            )
        else {
            return try await presenter.renderErrorPage(error: .forbidden)
        }
        do {
            return try await presenter.renderListPage(
                variantId: try request.requiredID(),
                model: try await interactor.list(
                    variantId: try request.requiredID(),
                    page: request.queryPage(),
                    search: request.querySearch()
                ),
                permissions: context.currentUserAdminListActions,
                search: request.querySearch()
            )
        }
        catch let error as AdminListMediaVariantProcessorsError {
            return try await presenter.renderErrorPage(error: error)
        }
    }

    func getAddMediaVariantProcessor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(
                to: MediaPermissions.VariantProcessors.create
            )
        else {
            return try await presenter.renderErrorPage(error: .forbidden)
        }
        return try await presenter.renderAddPage(
            variantId: try request.requiredID()
        )
    }
}
