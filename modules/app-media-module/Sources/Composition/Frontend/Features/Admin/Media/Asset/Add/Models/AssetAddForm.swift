import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AssetAddForm: Decodable {
    var parentId: String = ""
    var fileName: String = ""
    var `extension`: String = "bin"
    var title: String = ""
    var altText: String = ""
    var data: String = ""
    var view: String = "grid"
}
