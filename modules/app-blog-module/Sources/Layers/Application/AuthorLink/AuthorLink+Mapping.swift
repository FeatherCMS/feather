import BlogDomain
//
import BlogModule

//  AuthorLink.Model+DTOs.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension AuthorLink.Model {

    var asDetail: AuthorLink.Detail.Output {
        .init(
            id: id,
            authorId: authorId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
