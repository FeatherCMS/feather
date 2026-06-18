import Foundation

struct AdminAddAuthMagicLinkFormInput: Codable, Sendable, Equatable, Hashable {

    enum CodingKeys: String, CodingKey {
        case email
        case isPersistent = "is_persistent"
    }

    let email: String
    let isPersistent: CheckboxFormInput

    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    init(
        email: String,
        isPersistent: CheckboxFormInput
    ) {
        self.email = email
        self.isPersistent = isPersistent
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.isPersistent =
            try container.decodeIfPresent(
                CheckboxFormInput.self,
                forKey: .isPersistent
            ) ?? .init(value: false)
    }
}
