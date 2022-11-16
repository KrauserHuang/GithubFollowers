//
//  ErrorMessage.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/30.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername    = "This username created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    case unableToFavorite   = "There is an error favoriting this user. Please try again."
    case alreadyInFavorites = "You have already favorited this guy. You must REALLY like them!"
}
