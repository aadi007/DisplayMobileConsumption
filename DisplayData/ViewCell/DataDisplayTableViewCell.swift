//
//  DataDisplayTableViewCell.swift
//  DisplayData
//
//  Created by Aadesh Maheshwari on 1/18/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit

class DataDisplayTableViewCell: UITableViewCell {
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var quaterLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var q1VolumeLabel: UILabel!
    @IBOutlet weak var q1View: UIView!
    @IBOutlet weak var q2VolumeLabel: UILabel!
    @IBOutlet weak var q2View: UIView!
    @IBOutlet weak var q3VolumeLabel: UILabel!
     @IBOutlet weak var q3View: UIView!
    @IBOutlet weak var q4VolumeLabel: UILabel!
     @IBOutlet weak var q4View: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func hideQuaters() {
        q1View.isHidden = true
        q2View.isHidden = true
        q3View.isHidden = true
        q4View.isHidden = true
    }
    func configureCell(record: YearRecord) {
        dataLabel.text = "Total voume consumed: " + record.totalVolumeConusmed
        quaterLabel.text = "Q: " + record.year
        rankLabel.text = "Rank: " + (record.quaters.last?.rank.description ?? "0")
        hideQuaters()
        for index in 0..<record.quaters.count {
            let quarter = record.quaters[index]
            switch index {
            case 0:
                q1VolumeLabel.text = quarter.mobileDataVolume
                q1View.isHidden = false
                q1View.backgroundColor =  quarter.decreasedVolume ? UIColor.themeRedColor() : UIColor.themeGreenColor()
            case 1:
                q2VolumeLabel.text = quarter.mobileDataVolume
                q2View.isHidden = false
                q2View.backgroundColor =  quarter.decreasedVolume ? UIColor.themeRedColor() : UIColor.themeGreenColor()
            case 2:
                q3VolumeLabel.text = quarter.mobileDataVolume
                q3View.isHidden = false
                q3View.backgroundColor =  quarter.decreasedVolume ? UIColor.themeRedColor() : UIColor.themeGreenColor()
            case 3:
                q4VolumeLabel.text = quarter.mobileDataVolume
                q4View.isHidden = false
                q4View.backgroundColor =  quarter.decreasedVolume ? UIColor.themeRedColor() : UIColor.themeGreenColor()
            default:
                break
            }
        }
        self.selectionStyle = record.performannceDecreased ? UITableViewCell.SelectionStyle.default : .none
    }
}
