//
//  Permissions.swift
//  app-system-module
//

public import FeatherModuleKit

public enum Permissions: PermissionProvider {

    public static func all() -> Set<PermissionKey> {
        Admin.Permissions.all()
            .union(Permission.Permissions.all())
            .union(Variable.Permissions.all())
            .union(Job.Permissions.all())
    }
}
