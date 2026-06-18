import Foundation

struct MediaFolderDeleteForm: Decodable {
    var parentId: String = ""
    var search: String = ""
    var view: String = "grid"
    var page: Int = 1
}
