public import ContactModule
public import FeatherApplication

extension FormField.Detail {
    public struct Input: DTO {
        public let id: String
        public let formId: String?

        public init(id: String, formId: String?) {
            self.id = id
            self.formId = formId
        }
    }
}
