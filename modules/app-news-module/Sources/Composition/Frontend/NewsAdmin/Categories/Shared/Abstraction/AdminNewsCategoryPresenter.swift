import FeatherAdmin
import Hummingbird
import NewsAdminAPI
import NewsContracts

protocol AdminNewsCategoryPresenter: Sendable {
    func renderList(
        model: AdminNewsCategoryListModel,
        search: String,
        error: String?
    ) async throws -> HTMLResponse
    func renderForm(
        input: AdminNewsCategoryFormInput,
        error: String?,
        title: String,
        action: String,
        submitLabel: String,
        removeHref: String?
    ) async throws -> HTMLResponse
    func renderDetails(
        item: Components.Schemas.NewsCategoryDetailSchema
    ) async throws -> HTMLResponse
    func renderError(
        _ message: String
    ) async throws -> HTMLResponse
    func renderRemoveConfirmation(
        item: Components.Schemas.NewsCategoryDetailSchema
    ) async throws -> Response
    func renderCreated() -> Response
    func renderUpdated(
        id: String
    ) -> Response
    func renderRemoved() -> Response
}
