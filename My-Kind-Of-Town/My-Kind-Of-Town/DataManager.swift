//
//  DataManager.swift
//  My-Kind-Of-Town
//
//  Created by Vidur Subaiah on 2/7/23.
//

import Foundation

public class DataManager {
  
  // MARK: - Singleton Stuff
  public static let sharedInstance = DataManager()
    
  // Attribution: Lecture Videos
  let defaults = UserDefaults.standard
  var favorites: [String] = []
  
  //This prevents others from using the default '()' initializer
  fileprivate init() {
      // Attribution: https://www.hackingwithswift.com/example-code/system/how-to-save-user-settings-using-userdefaults
      // Attribution: https://stackoverflow.com/questions/25104700/check-if-userdefault-exists-swift
      if (self.defaults.array(forKey: "favorites") != nil) {
          self.favorites = self.defaults.array(forKey: "favorites") as? [String] ?? [String]()
      }
      else {
          self.favorites = []
      }
      self.defaults.set(self.favorites, forKey: "favorites")
  }

  func saveFavorite(_ place: String) {
      // Attribution: https://stackoverflow.com/questions/48558115/how-to-update-user-default-value-in-swift
      self.favorites.append(place)
      self.defaults.set(self.favorites, forKey: "favorites")
  }
    
  func deleteFavorite(_ place: String) {
      // Attribution: https://stackoverflow.com/questions/24051633/how-to-remove-an-element-from-an-array-in-swift
      if let indexPosition = self.favorites.firstIndex(of: place){
          self.favorites.remove(at: indexPosition)
      }
      self.defaults.set(self.favorites, forKey: "favorites")
  }
    
  func listFavorites() -> [String]{
      return self.favorites
  }
  
}
