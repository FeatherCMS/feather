//
//  Permissions.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit

public enum Permissions: PermissionProvider {
    public static func all() -> Set<PermissionKey> {
        Author.Permissions.all()
            .union(AuthorLink.Permissions.all())
            .union(Post.Permissions.all())
            .union(Tag.Permissions.all())
            .union(Settings.Permissions.all())
    }
}
