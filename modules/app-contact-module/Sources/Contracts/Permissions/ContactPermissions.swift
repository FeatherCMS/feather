import ContactModule
public import FeatherModuleKit

public enum ContactPermissions: PermissionProvider {
    public enum Forms: PermissionProvider {
        public static let create = ContactModule.Permissions.Forms.create
        public static let read = ContactModule.Permissions.Forms.read
        public static let update = ContactModule.Permissions.Forms.update
        public static let list = ContactModule.Permissions.Forms.list
        public static let delete = ContactModule.Permissions.Forms.delete

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Fields: PermissionProvider {
        public static let create = ContactModule.Permissions.Fields.create
        public static let read = ContactModule.Permissions.Fields.read
        public static let update = ContactModule.Permissions.Fields.update
        public static let list = ContactModule.Permissions.Fields.list
        public static let delete = ContactModule.Permissions.Fields.delete

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Submissions: PermissionProvider {
        public static let read = ContactModule.Permissions.Submissions.read
        public static let update = ContactModule.Permissions.Submissions.update
        public static let list = ContactModule.Permissions.Submissions.list
        public static let delete = ContactModule.Permissions.Submissions.delete

        public static func allPermissions() -> Set<PermissionKey> {
            [read, update, list, delete]
        }
    }

    public enum Mails: PermissionProvider {
        public static let create = ContactModule.Permissions.Mails.create
        public static let read = ContactModule.Permissions.Mails.read
        public static let update = ContactModule.Permissions.Mails.update
        public static let list = ContactModule.Permissions.Mails.list
        public static let delete = ContactModule.Permissions.Mails.delete

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        Forms.allPermissions().union(Fields.allPermissions())
            .union(Submissions.allPermissions())
            .union(Mails.allPermissions())
    }
}
