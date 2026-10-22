public import ContactDomain
public import ContactModule
public import FeatherApplication

extension Submission.Edit {
    public struct Input: DTO {
        public let formKey: String
        public let id: String
        public let status: Submission.Model.Status

        public init(
            formKey: String,
            id: String,
            status: Submission.Model.Status
        ) {
            self.formKey = formKey
            self.id = id
            self.status = status
        }
    }
}
