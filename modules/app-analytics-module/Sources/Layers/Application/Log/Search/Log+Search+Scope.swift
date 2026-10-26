public import AnalyticsModule
public import FeatherModuleKit

extension Log.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let log: any Query.Interface

        public init(log: any Query.Interface) {
            self.log = log
        }
    }
}
