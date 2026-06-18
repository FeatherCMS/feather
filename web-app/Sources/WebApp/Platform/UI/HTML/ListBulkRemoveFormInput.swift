import Foundation

struct ListBulkRemoveFormInput: Codable, Sendable {
    var selectedIds: [String]?
    var page: Int?
    var search: String?

    var normalizedSelectedIds: [String] {
        selectedIds ?? []
    }

    var normalizedPage: Int {
        max(page ?? 1, 1)
    }

    var normalizedSearch: String? {
        search?.nilIfEmpty
    }
}
