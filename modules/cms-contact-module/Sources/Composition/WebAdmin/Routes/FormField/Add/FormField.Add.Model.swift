import ContactApplication
import ContactModule

extension FormField.Add {
    struct Model: Sendable {
        let key: String
        let type: String
        let label: String
        let allowedValues: [String]
        let isRequired: Bool
        let position: String
        let error: String?
        let fieldErrors: [String: String]
    }
}
