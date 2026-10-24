import AuthModule

extension MagicLink.App.Form {
    struct Input: Codable, Sendable {
        let email: String
        let isPersistent: AuthFormCheckboxInput

        enum CodingKeys: String, CodingKey {
            case email
            case isPersistent = "is_persistent"
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            email = try container.decode(String.self, forKey: .email)
            isPersistent =
                try container.decodeIfPresent(
                    AuthFormCheckboxInput.self,
                    forKey: .isPersistent
                ) ?? .init(value: false)
        }
    }
}
