//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 01..
//

extension Login.Form {
    public struct Input: Codable, Sendable, Equatable, Hashable {

        enum CodingKeys: String, CodingKey {
            case email
            case password
            case isPersistent = "is_persistent"
        }

        public let email: String
        public let password: String
        public let isPersistent: AuthFormCheckboxInput

        public init(
            email: String,
            password: String,
            isPersistent: AuthFormCheckboxInput
        ) {
            self.email = email
            self.password = password
            self.isPersistent = isPersistent
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            email = try container.decode(String.self, forKey: .email)
            password = try container.decode(String.self, forKey: .password)
            isPersistent =
                try container.decodeIfPresent(
                    AuthFormCheckboxInput.self,
                    forKey: .isPersistent
                ) ?? .init(value: false)
        }
    }
}
