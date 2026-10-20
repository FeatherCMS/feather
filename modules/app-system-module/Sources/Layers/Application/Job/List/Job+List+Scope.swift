public import FeatherModuleKit
public import SystemModule

extension Job.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let job: any Query.Interface
        public init(job: any Query.Interface) { self.job = job }
    }
}
