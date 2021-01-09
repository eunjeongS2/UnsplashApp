//
//  MainViewController.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var photoCollectionView: UICollectionView!
    private var photos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        photos = mockupPhotos()
    }
    
    private func configureCollectionView() {
        PhotoCollectionViewCell.registerNib(collectionView: photoCollectionView)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    private func mockupPhotos() -> [UIImage] {
        let imagesURL = [
            "https://lh3.googleusercontent.com/proxy/wiLbq-P2WTDqpcqcN8N3EXXZgUK-mHV2V73-jbBCvWVnp6nvaVaPHYZp6i_Z-MqiOMmmKb8c5tCLcXI-EIfJRE69ccPnL-lZHtQ8Y4V-e_Y5cogRsHF6ffT3RaCmXmN7W3vSncK0nGvLjDMnBZfY85I",
            "https://i.ytimg.com/vi/ohtkpDDezLo/maxresdefault.jpg",
            "https://image.imnews.imbc.com/news/2013/culture/article/__icsFiles/afieldfile/2013/04/07/32.jpg",
            "https://image.auction.co.kr/itemimage/14/97/95/1497951b06.jpg"
        ]
        let datas = imagesURL.compactMap { URL(string: $0) }.compactMap { try? Data(contentsOf: $0) }
        
        return datas.compactMap { UIImage(data: $0) }
    }

}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = PhotoCollectionViewCell.Identifier.reusableCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        guard let photoCell = cell as? PhotoCollectionViewCell else { return cell }
        
        photoCell.configureCell(image: photos[indexPath.item])
        
        return photoCell
    }
    
}

extension MainViewController: UICollectionViewDelegate {}
