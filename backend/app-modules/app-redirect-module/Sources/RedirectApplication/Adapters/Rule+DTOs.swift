import RedirectDomain

extension Rule {

    var asDetail: RuleDetail {
        .init(
            id: id,
            source: source,
            destination: destination,
            statusCode: statusCode,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
