import FeatherAdmin
import FeatherValidation
import FeatherContracts
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AssetEditForm: Decodable {
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
