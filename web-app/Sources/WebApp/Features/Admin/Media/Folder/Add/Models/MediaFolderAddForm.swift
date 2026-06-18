import Foundation

struct MediaFolderAddForm: Decodable {
    var parentId: String = ""
    var name: String = ""
    var view: String = "grid"

    var normalizedParentId: String? {
        parentId.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
    }

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
