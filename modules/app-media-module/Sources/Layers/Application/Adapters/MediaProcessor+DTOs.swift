//
//  MediaProcessor+DTOs.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import MediaDomain

extension MediaProcessor {
    public var asProcessorDetail: MediaProcessorDetail {
        .init(
            id: id,
            name: name,
            matchExtensions: matchExtensions,
            commandTemplate: commandTemplate,
            isRequired: isRequired,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    public var asProcessorListItem: MediaProcessorList.Item {
        .init(
            id: id,
            name: name,
            matchExtensions: matchExtensions,
            commandTemplate: commandTemplate,
            isRequired: isRequired,
            isActive: isActive
        )
    }
}
