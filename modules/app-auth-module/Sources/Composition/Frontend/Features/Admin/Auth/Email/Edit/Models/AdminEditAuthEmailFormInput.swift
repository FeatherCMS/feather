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
import WebStandards

public struct AdminEditAuthEmailFormInput: Codable, Sendable, Equatable,
    Hashable
{

    enum CodingKeys: String, CodingKey {
        case identityId = "identity_id"
        case email
    }

    public let identityId: String
    public let email: String

    public var normalizedIdentityId: String {
        identityId.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public init(
        identityId: String,
        email: String = ""
    ) {
        self.identityId = identityId
        self.email = email
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identityId = try container.decode(
            String.self,
            forKey: .identityId
        )
        self.email = try container.decodeIfPresent(
            String.self,
            forKey: .email
        ) ?? ""
    }
}
