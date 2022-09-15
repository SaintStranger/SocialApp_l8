// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import UIKit

// MARK: - Welcome
struct NewsModel: Decodable {
    let response: Response
}

// MARK: - Response
struct Response: Decodable {
    let items: [Item]
    let profiles: [Profile]
    let groups: [GroupNews]
    let nextFrom: String?
    
    enum CodingKeys: String, CodingKey {
        case nextFrom = "next_from"
        case items, profiles, groups
    }
}

// MARK: - Item
struct Item: Decodable {
    let sourceId: Int
    let date: Double
    var sourceName: String = ""
    var sourceAvatar: String = ""
    let text: String
    let attachments: [ItemAttachment]?
    let comments: Comments
    let likes: Likes

    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case text, date, attachments
        case comments, likes
    }
    
    func getStringDate() -> String {
        let dateFormatter = VKDateFormatter()
        return dateFormatter.convertDate(timeIntervalSince1970: date)
    }
}


// MARK: - ItemAttachment
struct ItemAttachment: Decodable {
//    let video: Video?
    let photo: Photo?
    
    var photosURL: String? {
        get {
            let photoURL = self.photo?.sizes.last?.url
            return photoURL
        }
    }
}

// MARK: - Button
struct Button: Decodable {
    let action: Action
    let title: String
}

// MARK: - Action
struct Action: Decodable {
    let type, target: String
    let url: String
}

// MARK: - Photo
struct Photo: Decodable {
    let sizes: [Size]
}

// MARK: - Size
struct Size: Decodable {
    let url: String
    let height: Int
    let width: Int
    
    var aspectRatio: CGFloat { return CGFloat(height) / CGFloat(width) }
}


// MARK: - Video
struct Video: Decodable {
    let accessKey: String
    let canComment, canLike, canRepost, canSubscribe: Int
    let canAddToFaves, canAdd, comments, date: Int
    let videoDescription: String
    let duration: Int
    let image, firstFrame: [Size]
    let width, height, id, ownerID: Int
    let title: String
    let isFavorite: Bool
    let trackCode: String
    let views: Int

    enum CodingKeys: String, CodingKey {
        case accessKey = "access_key"
        case canComment = "can_comment"
        case canLike = "can_like"
        case canRepost = "can_repost"
        case canSubscribe = "can_subscribe"
        case canAddToFaves = "can_add_to_faves"
        case canAdd = "can_add"
        case comments, date
        case videoDescription = "description"
        case duration, image
        case firstFrame = "first_frame"
        case width, height, id
        case ownerID = "owner_id"
        case title
        case isFavorite = "is_favorite"
        case trackCode = "track_code"
        case views
    }
}

// MARK: - Comments
struct Comments: Decodable {
    let canPost, count: Int
    let groupsCanPost: Bool?

    enum CodingKeys: String, CodingKey {
        case canPost = "can_post"
        case count
        case groupsCanPost = "groups_can_post"
    }
}


// MARK: - Likes
struct Likes: Decodable {
    let canLike, count, userLikes, canPublish: Int

    enum CodingKeys: String, CodingKey {
        case canLike = "can_like"
        case count
        case userLikes = "user_likes"
        case canPublish = "can_publish"
    }
}


// MARK: - Reposts
struct Reposts: Decodable {
    let count, userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - Views
struct Views: Decodable {
    let count: Int
}

// MARK: - Profile
struct Profile: Decodable {
    let id, sex: Int
    let photo50, photo100: String
    let online: Int
    let deactivated: String?
    let firstName, lastName: String
    let screenName: String?

    enum CodingKeys: String, CodingKey {
        case id, sex
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case online, deactivated
        case firstName = "first_name"
        case lastName = "last_name"
        case screenName = "screen_name"
    }
    
    func mergeName() -> String {
        let name = firstName + " " + lastName
        return name
    }
}

// MARK: - Group
struct GroupNews: Decodable {
    let id: Int
    let name, screenName: String
    let photo50, photo100, photo200: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}


class VKDateFormatter {
    let dateFormatter = DateFormatter()

    func convertDate(timeIntervalSince1970: Double) -> String {
        dateFormatter.dateFormat = "MM.dd.yyyy HH.mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        return dateFormatter.string(from: date)
    }
}
