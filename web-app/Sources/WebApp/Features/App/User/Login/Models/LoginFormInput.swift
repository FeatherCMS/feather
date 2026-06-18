//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 01..
//

struct LoginFormInput: Codable, Sendable, Equatable, Hashable {

    enum CodingKeys: String, CodingKey {
        case email
        case password
        case isPersistent = "is_persistent"
    }

    let email: String
    let password: String
    let isPersistent: CheckboxFormInput

    init(
        email: String,
        password: String,
        isPersistent: CheckboxFormInput
    ) {
        self.email = email
        self.password = password
        self.isPersistent = isPersistent
    }

    init(from decoder: any Decoder) throws {
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
