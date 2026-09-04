import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

public struct AdminEditAuthAccessControlFormInput: Codable, Sendable {
    public let pairs: [String]?
    public let search: String?

    var selectedPairs: Set<String> {
        Set((pairs ?? []).filter { !$0.isEmpty })
    }
}
