public import UserModule

import FeatherModuleKit

extension Role.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
        }
    }
}
