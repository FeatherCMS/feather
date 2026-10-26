public import ContactModule
public import FeatherApplication

extension FormField.Remove {
    public struct Input: DTO {
        public let ids: [String]
        public let formId: String?

        public init(ids: [String], formId: String?) {
            self.ids = ids
            self.formId = formId
        }
    }
}
