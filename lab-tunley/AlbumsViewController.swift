//
//  AlbumsViewController.swift
//  lab-tunley
//
//  Created by Leonardo Villalobos on 2/22/23.
//

import UIKit
import Nuke

class AlbumsViewController: UIViewController {
    @IBOutlet weak var collectioinView: UICollectionView!
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
                DispatchQueue.main.async {
                    self.albums = response.results
                    self.collectioinView.reloadData()
                }
            } catch {
                fatalError("Parse error: \(error.localizedDescription)")
            }
            print("Closure end")
        }
        
        task.resume()
        collectioinView.dataSource = self
    }
}

// MARK: Conform AlbumsViewController to UICollectionViewDataSource
extension AlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumCell.identifier,
            for: indexPath
        ) as! AlbumCell
        let album = albums[indexPath.item]
        let imageURL = album.artworkUrl100
        Nuke.loadImage(with: imageURL, into: cell.albumImageView)
        return cell
    }
}
