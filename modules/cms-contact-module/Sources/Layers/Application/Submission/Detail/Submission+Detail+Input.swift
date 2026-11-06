public import ContactModule
public import FeatherApplication

extension Submission.Detail {
    public struct Input: DTO {
        public let formKey: String
        public let id: String

        public init(formKey: String, id: String) {
            self.formKey = formKey
            self.id = id
        }
    }
}
