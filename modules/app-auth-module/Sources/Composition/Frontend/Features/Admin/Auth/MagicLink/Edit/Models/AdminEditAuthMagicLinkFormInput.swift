import AuthAdminAPI
import AuthAppAPI
import CSS
public import FeatherAdmin
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
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

public struct AdminEditAuthMagicLinkFormInput: Codable, Sendable, Equatable,
    Hashable
{

    enum CodingKeys: String, CodingKey {
        case credentialId = "credential_id"
        case isPersistent = "is_persistent"
    }

    public let credentialId: String
    public let isPersistent: AdminFormFieldCheckbox.Input

    public var normalizedCredentialId: String {
        credentialId.whitespaceTrimmed
    }

    public init(
        credentialId: String,
        isPersistent: AdminFormFieldCheckbox.Input
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
                AdminFormFieldCheckbox.Input.self,
                forKey: .isPersistent
            ) ?? .init(value: false)
    }
}
