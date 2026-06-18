import MediaDomain

public extension MediaProcessor {
    var asProcessorDetail: MediaProcessorDetail {
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

    var asProcessorListItem: MediaProcessorList.Item {
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
