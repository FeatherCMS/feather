import ContactDomain
import ContactModule
import FeatherModuleKit

extension Submission.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let form: any Form.Repository.Interface
        public let submission: any Submission.Repository.Interface

        public init(
            form: any Form.Repository.Interface,
            submission: any Submission.Repository.Interface
        ) {
            self.form = form
            self.submission = submission
        }
    }
}
