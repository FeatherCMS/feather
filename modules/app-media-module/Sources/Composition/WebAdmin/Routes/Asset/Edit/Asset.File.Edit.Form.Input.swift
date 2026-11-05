import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Edit.Form {
    struct Input: Decodable {
        var title: String = ""
        var altText: String = ""

        var normalizedTitle: String? {
            let value = title.whitespaceTrimmed
            return value.isEmpty ? nil : value
        }

        var normalizedAltText: String? {
            let value = altText.whitespaceTrimmed
            return value.isEmpty ? nil : value
        }
    }
}
