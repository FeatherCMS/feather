//
//  Metadata+DTOs.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import WebDomain

extension Metadata {

    public var asDetail: MetadataDetail {
        .init(
            id: id,
            referenceType: reference.type,
            referenceID: reference.id ?? "[!!!INVALID!!!]",
            template: template,
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: status,
            title: title,
            excerpt: excerpt,
            imageURL: imageURL,
            canonicalURL: canonicalURL,
            noIndex: noIndex,
            primaryKeyword: primaryKeyword,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
