import BlogDomain

extension Settings {
    var asDetail: SettingsDetail {
        .init(
            id: id,
            postListPath: postListPath,
            authorListPath: authorListPath,
            tagListPath: tagListPath,
            postPathPrefix: postPathPrefix,
            authorPathPrefix: authorPathPrefix,
            tagPathPrefix: tagPathPrefix
        )
    }
}
