import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaFolderDeleteForm: Decodable {
    var parentId: String = ""
    var search: String = ""
    var view: String = "grid"
    var page: Int = 1
}
