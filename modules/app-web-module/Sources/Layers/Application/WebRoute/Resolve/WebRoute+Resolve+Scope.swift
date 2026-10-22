public import FeatherModuleKit
import WebModule

extension WebRoute.Resolve {
    public struct Scope: FeatherModuleKit.Scope {
        public let metadata: any Query.Interface

        public init(metadata: any Query.Interface) {
            self.metadata = metadata
        }
    }
}
