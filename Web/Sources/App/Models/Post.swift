//
//  Post.swift
//  
//
//  Created by James Wolfe on 16/07/2023.
//

import Fluent
import Vapor
import Logic

final class Post: Model, Content {
    static let schema = "posts"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "body")
    var body: String
    
    @Timestamp(key: "created_at", on: .create, format: .iso8601)
    var createdAt: Date?
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }

    init(id: UUID? = nil, title: String, body: String, userID: User.IDValue) {
        self.id = id
        self.title = title
        self.body = body
        self.$user.id = userID
    }
}

extension Post {
    var response: PostResponse {
        return .init(id: id!, title: title, body: body, createdAt: createdAt!)
    }
}

extension PostResponse: Content { }

extension PostRequest: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("body", as: String.self, is: !.empty)
    }
}
