public import ContactModule
public import FeatherApplication

extension Submission.Remove {
    public struct Input: DTO {
        public let formKey: String
        public let ids: [String]

        public init(formKey: String, ids: [String]) {
            self.formKey = formKey
            self.ids = ids
        }
    }
}
