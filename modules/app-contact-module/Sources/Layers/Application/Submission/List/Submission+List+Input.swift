public import ContactModule
public import FeatherApplication

extension Submission.List {
    public struct Input: DTO {
        public let formKey: String

        public init(formKey: String) {
            self.formKey = formKey
        }
    }
}
