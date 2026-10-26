public import ContactModule
public import FeatherModuleKit

extension Submission.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let submission: any Query.Interface

        public init(submission: any Query.Interface) {
            self.submission = submission
        }
    }
}
