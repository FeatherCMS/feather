//
//  BlogModule.Permissions.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit

extension BlogModule {
    public enum Permissions: PermissionProvider {
        public static func allPermissions() -> Set<PermissionKey> {
            Author.Permissions.allPermissions()
                .union(AuthorLink.Permissions.allPermissions())
                .union(Post.Permissions.allPermissions())
                .union(Tag.Permissions.allPermissions())
                .union(Settings.Permissions.allPermissions())
        }
    }
}
