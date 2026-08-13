import FeatherApplication
import FeatherContracts

public struct Action: PermissionAction {
    public let key: PermissionKey

    public init(
        key: PermissionKey
    ) {
        self.key = key
    }
}
