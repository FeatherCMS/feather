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

public struct AdminEditAuthProfileFormInput: Codable, Sendable, Equatable,
    Hashable
{

    public var firstName: String? = nil
    public var lastName: String? = nil
    public var profileImageAssetId: String? = nil
}
