import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule

extension Variant.List {
    enum Presenter {}
}

extension Variant.List.Presenter {
    protocol Interface: Sendable {
        func renderListPage(
            model: AdminListModel<
                MediaAdminAPI.Components.Schemas.MediaVariantQueryItemSchema
            >,
            permissions: AdminListActions,
            search: String?
        ) async throws -> HTMLResponse

        func renderErrorPage(error: Variant.List.Error) async throws
            -> HTMLResponse
    }
}
