public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func allPermissions() -> Set<PermissionKey> {
        Form.Permissions.allPermissions()
            .union(FormField.Permissions.allPermissions())
            .union(Submission.Permissions.allPermissions())
            .union(SubmissionMail.Permissions.allPermissions())
    }
}
