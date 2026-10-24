public import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherDomain

extension Submission.Edit {
    public struct Input: DTO {
        public let formKey: String
        public let id: String
        public let status: FieldChange<Submission.Model.Status>

        public init(
            formKey: String,
            id: String,
            status: FieldChange<Submission.Model.Status>
        ) {
            self.formKey = formKey
            self.id = id
            self.status = status
        }
    }
}
