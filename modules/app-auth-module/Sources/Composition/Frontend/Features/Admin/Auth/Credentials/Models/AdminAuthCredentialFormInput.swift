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

public struct AdminAuthCredentialFormInput: Codable, Sendable, Equatable,
    Hashable
{
    public let userId: String
    public let email: String
    public let password: String

    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedPassword: String? {
        let value = password.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }

    var normalizedUserId: String {
        userId.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
