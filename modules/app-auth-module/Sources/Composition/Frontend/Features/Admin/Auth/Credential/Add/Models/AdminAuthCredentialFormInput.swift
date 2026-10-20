import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherModuleKit
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

public struct AdminAuthCredentialFormInput: Codable, Sendable, Equatable,
    Hashable
{
    public let userId: String
    public let email: String
    public let password: String

    var normalizedEmail: String {
        email.whitespaceTrimmed
    }

    var normalizedPassword: String? {
        let value = password.whitespaceTrimmed
        return value.isEmpty ? nil : value
    }

    var normalizedUserId: String {
        userId.whitespaceTrimmed
    }
}
