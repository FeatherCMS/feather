import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import WebContracts

struct AdminListWebMetadataDefaultController:
    AdminListWebMetadataController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListWebMetadataInteractor,
            presenter: any AdminListWebMetadataPresenter
        )

    func getMetadataEntries(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let referenceType = request.queryString("referenceType")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedReferenceType =
            referenceType?.isEmpty == true
            ? nil
            : referenceType
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: WebPermissions.Metadata.list
        )
        let emptyModel = AdminListWebMetadataModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListWebMetadataModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listMetadataEntries(
                    page: page,
                    search: search,
                    referenceType: normalizedReferenceType
                )
                error = nil
            }
            catch let caughtError {
                model = emptyModel
                error = caughtError.displayMessage
            }
        }
        else {
            model = emptyModel
            error = nil
        }
        return presenter.renderListPage(
            model: model,
            isEdited: request.hasQueryFlag("edited"),
            permissions: permissions,
            search: search,
            referenceType: normalizedReferenceType,
            error: error
        )
    }
}
