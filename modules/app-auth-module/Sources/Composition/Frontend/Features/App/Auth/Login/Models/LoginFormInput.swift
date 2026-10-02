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
        case turnstileResponse = "cf-turnstile-response"
    }

    public let email: String
    public let password: String
    public let isPersistent: CheckboxFormInput
    public let turnstileResponse: String?

    public init(
        email: String,
        password: String,
        isPersistent: CheckboxFormInput,
        turnstileResponse: String? = nil
    ) {
        self.email = email
        self.password = password
        self.isPersistent = isPersistent
        self.turnstileResponse = turnstileResponse
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
        self.turnstileResponse = try container.decodeIfPresent(
            String.self,
            forKey: .turnstileResponse
        )
    }
}
