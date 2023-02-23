//
//  AlbumsViewController.swift
//  lab-tunley
//
//  Created by Leonardo Villalobos on 2/22/23.
//

import UIKit

class AlbumsViewController: UIViewController {
    var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://itunes.apple.com/search?term=bad+bunny&attribute=artistTerm&entity=album&media=music";
        let request = URLRequest(url: .init(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                fatalError("Network error: \(error.localizedDescription)")
            }
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(AlbumsSearchResponse.self, from: data)
                self.albums = response.results
            } catch {
                fatalError("Parse error: \(error.localizedDescription)")
            }
            print("Closure end")
        }
        
        task.resume()
    }
}
