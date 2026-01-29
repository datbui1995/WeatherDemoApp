//
//  CityCell.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//
import UIKit
final class CityCell: UITableViewCell {
    
    static let reuseIdentifier = "CityCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
    }
    
    func configure(with city: City) {
        var content = UIListContentConfiguration.subtitleCell()
        content.text = "\(city.name), \(city.country)"
        content.secondaryText = "Population: \(city.population)"
        content.secondaryTextProperties.color = .secondaryLabel
        
        self.contentConfiguration = content
    }
}
