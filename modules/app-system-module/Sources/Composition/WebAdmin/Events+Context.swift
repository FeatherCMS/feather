public import FeatherModuleKit

public enum Events {}

extension Events {
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
