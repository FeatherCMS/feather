public import UserModule

import FeatherModuleKit

extension Identity.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
        }
    }
}
