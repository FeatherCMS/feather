public import FeatherModuleKit

extension Admin.Menu {
    public struct Context: ExecutionContext {
        public let path: String
        public let permissions: Set<String>

        public init(
            path: String,
            permissions: Set<String>
        ) {
            self.path = path
            self.permissions = permissions
        }
    }
}
