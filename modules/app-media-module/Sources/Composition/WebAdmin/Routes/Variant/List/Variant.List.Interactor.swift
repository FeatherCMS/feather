import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule

extension Variant.List {
    enum Interactor {}
}

extension Variant.List.Interactor {
    protocol Interface: Sendable {
        func list(
            page: Int,
            search: String?
        ) async throws -> AdminListModel<
            MediaAdminAPI.Components.Schemas.MediaVariantQueryItemSchema
        >
    }
}
