import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
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
