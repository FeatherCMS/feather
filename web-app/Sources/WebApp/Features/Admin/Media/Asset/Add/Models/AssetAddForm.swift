import Foundation

struct AssetAddForm: Decodable {
    var parentId: String = ""
    var fileName: String = ""
    var type: String = "bin"
    var title: String = ""
    var altText: String = ""
    var data: String = ""
    var view: String = "grid"
}
