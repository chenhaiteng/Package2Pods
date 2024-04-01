//
//  TemplateTags.swift
//  Package2Pods
//
//  Created by Chen Hai Teng on 4/1/24.
//

import Foundation

// Define template format
enum GitInfoKeys {
    static let tag = "${GIT_TAG}"
}

enum PodReplaceKeys {
    static let user_name = "${USER_NAME}"
    static let user_email = "${USER_EMAIL}"
    static let git_remote = "${GIT_REMOTE}"
    static let pod_name = "${POD_NAME}"
    static let version = GitInfoKeys.tag
}

enum InsertSpecs {
    static let swift_version = "swift_version"
    static let platforms = "platform"
    static let dependencies = "dependency"
}
