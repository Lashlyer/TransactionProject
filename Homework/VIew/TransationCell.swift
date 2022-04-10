

import Foundation
import UIKit
import SnapKit

class TransationCell : UITableViewCell {
    
    static let identifier = "TransationCell"
    
    private let titlelabel : UILabel = {
        return UILabel()
    }()
    
    private let priceLabel : UILabel = {
        return UILabel()
    }()
    
    private let countLabel : UILabel = {
        return UILabel()
    }()
    
    private let totalpriceLabel : UILabel = {
        return UILabel()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContentView() {
        contentView.addSubview(titlelabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(totalpriceLabel)
    }
    
    private func autoLayout() {
        titlelabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(40)
            make.left.equalTo(contentView).offset(10)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(70)
            make.left.equalTo(contentView).offset(10)
        }
        
        totalpriceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(100)
            make.left.equalTo(contentView).offset(10)
        }
        
        
    }
    
    
    func setValue(data: TrxDTODetail) {
        self.titlelabel.text = "名稱： \(data.name)"
        self.priceLabel.text = "單價： \(data.price)"
        self.countLabel.text = "數量： \(data.quantity)"
        self.totalpriceLabel.text = "總價： \(data.total)"
    }
}
