//
//  PersistenceManager.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/15.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    private static let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    /*
     將某某使用者加入我的最愛
     1.先取得我的最愛列表
     */
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites): //取得 favorites 後就要進行新增(add)或刪減(remove)
                switch actionType {
                case .add: //確認該名使用者是否已經被加進list裏面，沒有才可以加
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.login == favorite.login } //篩選要移除的使用者，對應完兩邊的 login(id)
                }
            case .failure(let error):
                completed(error) //這裡的 error 會回傳至 retrieveFavorites 內的 GFError，最後跑 .unableFavorite 錯誤訊息
            }
        }
    }
    
    /*
     取得我的最愛列表(favorite followers)
     */
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        //先從 UserDefaults 去取得資料(需給予對應的key)，若沒有資料則顯示空的 follower list
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        //有的話記得將資料(Data)轉回我們要的格式型別
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    /*
     儲存我的最愛列表(favorite followers)
     */
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites) // encode動作
            defaults.set(encodedFavorites, forKey: Keys.favorites) // 將 encode 完的資料儲存在 UserDefaults
            return nil // 儲存成功，沒有錯誤
        } catch {
            return .unableToFavorite
        }
        return nil
    }
}
