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

struct AddProcessorForm: Decodable {
    var fileSuffix: String = ""
    var matchExtensions: String = ""
    var commandTemplate: String = ""
}
