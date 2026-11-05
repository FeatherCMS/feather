public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func all() -> Set<PermissionKey> {
        Form.Permissions.all()
            .union(FormField.Permissions.all())
            .union(Submission.Permissions.all())
            .union(SubmissionMail.Permissions.all())
    }
}
