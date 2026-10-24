import FeatherValidation
import MediaModule

extension Asset.File.Add.Form {
    struct Input: Decodable {
        var parentId: String = ""
        var fileName: String = ""
        var `extension`: String = "bin"
        var title: String = ""
        var altText: String = ""
        var data: String = ""
        var view: String = "grid"
    }
}
