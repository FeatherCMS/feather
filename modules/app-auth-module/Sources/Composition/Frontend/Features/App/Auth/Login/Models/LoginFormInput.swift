import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
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

//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 01..
//

public struct LoginFormInput: Codable, Sendable, Equatable, Hashable {

    enum CodingKeys: String, CodingKey {
        case email
        case password
        case isPersistent = "is_persistent"
    }

    public let email: String
    public let password: String
    public let isPersistent: CheckboxFormInput

    public init(
        email: String,
        password: String,
        isPersistent: CheckboxFormInput
    ) {
        self.email = email
        self.password = password
        self.isPersistent = isPersistent
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.isPersistent =
            try container.decodeIfPresent(
                CheckboxFormInput.self,
                forKey: .isPersistent
            ) ?? .init(value: false)
    }
}
