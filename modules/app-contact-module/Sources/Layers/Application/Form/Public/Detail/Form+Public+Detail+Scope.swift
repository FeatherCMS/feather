import ContactDomain
import ContactModule
import FeatherModuleKit

extension Form.Public.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let form: any Form.Repository.Interface
        public let field: any FormField.Repository.Interface
        public let mail: any SubmissionMail.Repository.Interface

        public init(
            form: any Form.Repository.Interface,
            field: any FormField.Repository.Interface,
            mail: any SubmissionMail.Repository.Interface
        ) {
            self.form = form
            self.field = field
            self.mail = mail
        }
    }
}
