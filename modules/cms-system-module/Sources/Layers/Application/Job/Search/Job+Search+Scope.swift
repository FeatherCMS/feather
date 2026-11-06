public import FeatherModuleKit
public import SystemModule

extension Job.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let job: any Query.Interface

        public init(job: any Query.Interface) {
            self.job = job
        }
    }
}
