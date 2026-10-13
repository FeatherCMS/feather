import FeatherAdmin
import FeatherContracts
import Hummingbird
import NewsAdminAPI
import NewsContracts

protocol AdminNewsArticlePresenter: Sendable {
    func renderList(
        model: AdminNewsArticleListModel,
        search: String,
        error: String?
    ) async throws -> HTMLResponse
    func renderForm(
        input: AdminNewsArticleFormInput,
        categories: [AdminNewsArticleCategoryOption],
        error: String?,
        title: String,
        action: String,
        submitLabel: String,
        removeHref: String?
    ) async throws -> HTMLResponse
    func renderDetails(
        item: Components.Schemas.NewsArticleDetailSchema
    ) async throws -> HTMLResponse
    func renderError(
        _ message: String
    ) async throws -> HTMLResponse
    func renderRemoveConfirmation(
        item: Components.Schemas.NewsArticleDetailSchema
    ) async throws -> Response
    func renderCreated() -> Response
    func renderUpdated(
        id: String
    ) -> Response
    func renderRemoved() -> Response
}
