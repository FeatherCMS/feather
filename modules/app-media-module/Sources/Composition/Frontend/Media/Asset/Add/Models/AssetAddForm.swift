import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AssetAddForm: Decodable {
    var parentId: String = ""
    var fileName: String = ""
    var type: String = "bin"
    var title: String = ""
    var altText: String = ""
    var data: String = ""
    var view: String = "grid"
}
