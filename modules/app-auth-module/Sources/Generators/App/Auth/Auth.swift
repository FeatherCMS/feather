import FeatherOpenAPI
import FeatherOpenAPIGenerator

enum Auth {
    enum Login {}
    enum Logout {}
    enum MagicLink {
        enum Verify {}
    }
    enum Me {}
}

extension Auth {
    protocol Operation: OperationRepresentable {}
}
