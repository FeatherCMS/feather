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

public struct AdminEditAuthMagicLinkFormInput: Codable, Sendable, Equatable,
    Hashable
{

    enum CodingKeys: String, CodingKey {
        case credentialId = "credential_id"
        case isPersistent = "is_persistent"
    }

    public let credentialId: String
    public let isPersistent: CheckboxFormInput

    public var normalizedCredentialId: String {
        credentialId.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public init(
        credentialId: String,
        isPersistent: CheckboxFormInput
    ) {
        self.credentialId = credentialId
        self.isPersistent = isPersistent
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.credentialId = try container.decode(
            String.self,
            forKey: .credentialId
        )
        self.isPersistent =
            try container.decodeIfPresent(
                CheckboxFormInput.self,
                forKey: .isPersistent
            ) ?? .init(value: false)
    }
}
