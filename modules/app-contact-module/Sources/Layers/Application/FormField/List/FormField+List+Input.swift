public import ContactModule
public import FeatherApplication

extension FormField.List {
    public struct Input: DTO {
        public let formId: String?
        public let formKey: String?
        public let isUnassigned: Bool

        public init(
            formId: String?,
            formKey: String? = nil,
            isUnassigned: Bool = false
        ) {
            self.formId = formId
            self.formKey = formKey
            self.isUnassigned = isUnassigned
        }
    }
}
