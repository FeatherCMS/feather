import ContactApplication
import ContactModule

extension FormField {
    struct Model: Sendable {
        let id: String
        let key: String
        let type: String
        let label: String
        let allowedValues: [String]
        let isRequired: Bool
        let position: String
    }
}
