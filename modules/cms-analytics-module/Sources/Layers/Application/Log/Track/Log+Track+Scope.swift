public import AnalyticsDomain
public import AnalyticsModule
public import FeatherModuleKit

extension Log.Track {
    public struct Scope: FeatherModuleKit.Scope {
        public let log: any Log.Repository.Interface

        public init(log: any Log.Repository.Interface) {
            self.log = log
        }
    }
}
