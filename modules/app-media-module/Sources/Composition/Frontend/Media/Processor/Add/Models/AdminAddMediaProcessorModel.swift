import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddMediaProcessorModel: Sendable {
    let fileSuffix: String
    let matchExtensions: String
    let commandTemplate: String
    let error: String?
}
