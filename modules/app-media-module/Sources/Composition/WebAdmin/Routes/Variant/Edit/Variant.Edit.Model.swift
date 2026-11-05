import MediaModule

extension Variant.Edit {
    struct Model: Sendable {
        let id: String
        let key: String
        let name: String
        let isRequired: Bool
        let isActive: Bool
    }
}
