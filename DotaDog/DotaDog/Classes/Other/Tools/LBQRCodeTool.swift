//
//  LBQRCodeTool.swift
//  二维码
//
//  Created by 林彬 on 16/5/5.
//  Copyright © 2016年 linbin. All rights reserved.
//

/**
*二维码的生成,扫描和识别的工具类
*
*提供类方法
*开始扫描方法: LBQRCodeTool.shareInstance.startScan
*关闭扫描方法: LBQRCodeTool.shareInstance.stopScan
***/

import UIKit
import AVFoundation
import CoreFoundation

// 闭包
typealias ScanResult = (resultStrs: String)->()


class LBQRCodeTool: NSObject {
    // 判断当前扫描的状态
    var isScan : Bool = false
    
    // 保存上一次扫到的结果
    var perResult :String?
    
    // 单例
    static let shareInstance = LBQRCodeTool()
    
    // 扫描结果的闭包
    private var scanResultBlock: ScanResult?
    
    // 懒加载输入
    private lazy var input: AVCaptureDeviceInput? = {
        
        // 1. 获取摄像头设备
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        // 1.1 设置为输入设备
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: device)
            
        }catch {
            print(error)
            return nil
        }
        
        return input
        
    }()
    
    // 懒加载输出
    private lazy var output: AVCaptureMetadataOutput = {
        // 2. 创建元数据输出处理对象
        let output = AVCaptureMetadataOutput()
        // 2.1 设置元数据输出处理的代理, 来接收输出的数据内容
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        return output
        
    }()
    
    // 会话
    private lazy var session: AVCaptureSession = {
        // 3. 创建会话, 连接输入和输出
        let session = AVCaptureSession()
        return session
        
    }()
    
    // 预览图层
    private lazy var layer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        return layer
        
    }()
    
    // 扫描二维码的时候是否给二维码加上边框
    var isDraw: Bool = false
    
    // 全局的path
    var framePath : UIBezierPath?
}

// MARK:- 生成和识别二维码
extension LBQRCodeTool {
    // MARK:- 生成二维码
    class func generatorQRCode(contentStr : String , centerImage :UIImage?) -> UIImage {
        
        // 1:新建一个二维码滤镜
        let fiter = CIFilter(name: "CIQRCodeGenerator")
        
        // 1.1:先让这个滤镜恢复默认设置,避免以前的一些配置影响现在的程序
        fiter?.setDefaults()
        
        // 2:利用KVC,设置滤镜的输入内容
        // 要注意的是,输入内容必须是NSData,需要先把String转成NSData
        let inputStr = contentStr
        let inputData = inputStr.dataUsingEncoding(NSUTF8StringEncoding)
        // 利用KVC设置输入内容
        fiter?.setValue(inputData, forKey: "inputMessage")
        
        // 2.1 :设置滤镜的纠错率.纠错率越高,二维码越复杂,中间可遮挡区域越多.一般M即可
        fiter?.setValue("M", forKey: "inputCorrectionLevel")
        
        // 3:取出生成的图片
        var outImage = fiter?.outputImage
        // 生成的图片默认大小是23,23.需要放大,放大20倍,让它清晰起来
        let transform = CGAffineTransformMakeScale(20, 20)
        outImage = outImage?.imageByApplyingTransform(transform)
        
        // 4:展示生成的图片
        // 先转换类型
        var QRCodeImage = UIImage(CIImage: outImage!)
        
        // 5:在生成的图片上覆盖一张小图片
        if centerImage != nil {
            QRCodeImage = creatCoverImage(QRCodeImage, coverImage: centerImage!)
        }
        
        return QRCodeImage
    }
    
    // MARK:- 识别图片中的二维码
    class func detectorQRCode( sourceImage :UIImage , isDrawFrame : Bool) -> (resultImage :UIImage, resultStrings : [String] ) {
        // 1: 创建二维码探测器
        /*
        CIDetectorTypeQRCode:扫描类型.还可以扫描人脸和文字
        CIDetectorAccuracy : 准确性
        */
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        
        
        // 2:探测图片特征
        let image = sourceImage
        let imageCI = CIImage(image: image)  // 类型转换
        // 获取到的是识别出来的二维码特征,是个数组
        let result = detector.featuresInImage(imageCI!)
        
        // 3:遍历特征,打印结果
        var strs = [String]()
        var tempImage = image
        for feature in result {
            // 数组result里保存的都是CIQRCodeFeature类型的数据
            let qrCodeFeature = feature as! CIQRCodeFeature
            
            // 把信息放到字符串数组中
            strs.append(qrCodeFeature.messageString)
            // 判断要不要边框
            if isDrawFrame {
                tempImage = drawFrame(tempImage, feature: qrCodeFeature)
            }
        }
//        sourceImage = tempImage
        
        return (tempImage , strs)
        
    }

}

extension LBQRCodeTool {
    // 在生成的二维码上再添加一张图片
    class private func creatCoverImage(sourceImage :UIImage , coverImage : UIImage) -> UIImage {
        
        let size = sourceImage.size
        
        // 1:开启图片上下文
        UIGraphicsBeginImageContext(size)
        
        // 2:绘制源图片
        sourceImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        // 3:绘制覆盖图片
        let w : CGFloat = 80
        let h  : CGFloat = 80
        let x = (size.width - 80) * 0.5
        let y = (size.height - 80) * 0.5
        coverImage.drawInRect(CGRectMake(x, y, w, h))
        
        // 4:获得结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5:关闭上下文
        UIGraphicsEndImageContext()
        
        // 6:返回结果图片
        return resultImage
    }
    
    // 给识别出来的二维码加上边框
    class private func drawFrame(sourceImage : UIImage , feature : CIQRCodeFeature) -> UIImage{
        
        let size = sourceImage.size
        
        // 1:开启上下文
        UIGraphicsBeginImageContext(size)
        
        // 2:绘制图片
        sourceImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        // 修改坐标(上下颠倒)
        /*
        为什么要上下颠倒?
        因为图片特征feature的bounds,是依照图片的坐标来算的.
        我们原先都是以屏幕坐标系来算的,屏幕坐标系的原点在左上角.
        而图片坐标系的原点是在图片的左下角.刚好上下颠倒.
        所以如果不做坐标上下颠倒处理,那么绘制的边框正好和识别出来的二维码呈上下颠倒姿态.
        */
        // 获取当前上下文
        let context = UIGraphicsGetCurrentContext()
        // 上下文的y方向缩放-1,就相当于上下文上下翻了个个.
        CGContextScaleCTM(context, 1, -1)
        // 翻转完后,要把上下文移回到原来的位置.因为前面把坐标系的y值改成负的了,这里也要改成负的
        CGContextTranslateCTM(context, 0, -size.height)
        
        // 3:绘制线宽
        let path = UIBezierPath(rect: feature.bounds)
        UIColor.orangeColor().setStroke()  // 线的颜色
        path.lineWidth = 6
        path.stroke()  // 样式是边框
        
        // 4:取出合成后的图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5:关闭上下文
        UIGraphicsEndImageContext()
        
        // 6:返回图片
        return resultImage
    }
    
}

// MARK:- 扫描二维码
extension LBQRCodeTool {
    // MARK:- 扫描二维码
    func startScan(inView: UIView, isDraw: Bool, interestRect : CGRect , resultBlock: ScanResult?) {
        
        // 1. 记录block, 在合适的地方执行
        scanResultBlock = resultBlock
        self.isDraw = isDraw
        
        // 2. 创建会话, 连接输入和输出
        if session.canAddInput(input) && session.canAddOutput(output)
        {
            session.addInput(input)
            session.addOutput(output)
        }
        
        // 2.1 设置扫描识别的类型
        // output.availableMetadataObjectTypes, 识别所有的类型
        // 如果设置这个属性, 在添加到session之前会崩溃
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // 2.2 添加视频预览图层
        let sublayers = inView.layer.sublayers
        if sublayers == nil || !sublayers!.contains(layer)
        {
            layer.frame = inView.bounds
            inView.layer.insertSublayer(layer, atIndex: 0)
        }
        
        
        // 3. 设置扫描区域
        setInterestRect(interestRect)
        
        
        // 4. 启动会话, 开始扫描
        session.startRunning()
    }
    
    func stopScan() {
        // 停止扫描后,需要关闭会话
        isScan = false
        removeQRCodeFrameLayer()
        session.stopRunning()
    }
    
    // 3 设置扫描区域
    func setInterestRect(rect: CGRect) -> () {
        // 1. 这个矩形, 是一个比例(0.0 - 1.0)
        // 2. 这个矩形, 是横屏状态下的矩形
        let size = UIScreen.mainScreen().bounds
        let x: CGFloat = rect.origin.x / size.width
        let y: CGFloat = rect.origin.y / size.height
        let w: CGFloat = rect.size.width / size.width
        let h: CGFloat = rect.size.height / size.height
        
        output.rectOfInterest = CGRectMake(y, x, h, w)
    }
}

extension LBQRCodeTool {
    // 扫描二维码的时候添加边框
    private func drawQRCodeFrame(codeObj: AVMetadataMachineReadableCodeObject) -> () {
        
        // 绘制边框
        // 1. 创建图形的图层
        let shapLayer = CAShapeLayer()
        shapLayer.fillColor = UIColor.clearColor().CGColor
        shapLayer.strokeColor = UIColor.orangeColor().CGColor
        shapLayer.lineWidth = 6
        // 2. 设置需要显示的图形路径
        let corners = codeObj.corners
        // 2.1 创建一个路径
        let path = UIBezierPath()
        
        var index = 0
        // 获取二维码4个角的4个点
        for corner in corners { 
            // 转换成为一个CGPoint
            var point  = CGPointZero
            CGPointMakeWithDictionaryRepresentation((corner as! CFDictionary), &point)
            
            if index == 0 {
                path.moveToPoint(point)
            }else {
                path.addLineToPoint(point)
            }
            
            index += 1
        }
        // 让线闭合
        path.closePath()
        path.lineWidth = 1
        
       framePath = path
        
        shapLayer.path = path.CGPath
        // 3. 添加到需要展示的图层
        layer.addSublayer(shapLayer)
        
    }
    
    private func removeQRCodeFrameLayer() -> () {
        guard let subLayers = layer.sublayers else { return }
        
        for subLayer in subLayers {
            if subLayer.isKindOfClass(CAShapeLayer) {
                subLayer.removeFromSuperlayer()
            }
        }
    }
}

// MARK:- 代理方法
extension LBQRCodeTool : AVCaptureMetadataOutputObjectsDelegate {
    // 扫描到结果之后, 调用
    // 最后一次也会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if isDraw {
            removeQRCodeFrameLayer()
        }
        
        var strs = [String]()
        for obj in metadataObjects {
            
            // AVMetadataMachineReadableCodeObject, 二维码的数据模型
            if obj.isKindOfClass(AVMetadataMachineReadableCodeObject)
            {
                // 借助layer来转换,,四个角的坐标
                let resultObj = layer.transformedMetadataObjectForMetadataObject(obj as! AVMetadataObject)
                
                
                let codeObj = resultObj as! AVMetadataMachineReadableCodeObject
                strs.append(codeObj.stringValue)
                // 描绘边框
                if isDraw {
                    drawQRCodeFrame(codeObj)
                }
            }
            
        }
        
        // 把数组转换成string,进行编码转换
        var resultString : String
        if strs != [] {
            resultString  = strs[0]
        }else {
            resultString = ""
            
        }
        
        if perResult == resultString { return }
        // 做判断,防止在一次扫描成功的情况下多次输出同一个结果.扫描成功一次就输出一次.
        if scanResultBlock != nil {
            if resultString == "" {
                perResult = resultString
                return
            }
            let sss = startEncoding(resultString)
            scanResultBlock!(resultStrs: sss as String)
        }
        perResult = resultString
    
        

    }
}

extension LBQRCodeTool {
     func startEncoding(str : String) -> NSString {
        var resultStr :NSString?
       
        
        if str.canBeConvertedToEncoding(NSShiftJISStringEncoding) {
            resultStr = NSString(CString: str.cStringUsingEncoding(NSShiftJISStringEncoding)!, encoding: NSUTF8StringEncoding)
            //如果转化成utf-8失败，再尝试转化为gbk
            if resultStr == nil {
                let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
                resultStr = NSString(CString: str.cStringUsingEncoding(NSShiftJISStringEncoding)!, encoding: enc)
            }
            
        }else if str.canBeConvertedToEncoding(NSISOLatin1StringEncoding) {
            resultStr = NSString(CString: str.cStringUsingEncoding(NSISOLatin1StringEncoding)!, encoding: NSUTF8StringEncoding)
            //如果转化成utf-8失败，再尝试转化为gbk
            if resultStr == nil {
                let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
                resultStr = NSString(CString: str.cStringUsingEncoding(NSISOLatin1StringEncoding)!, encoding: enc)
            }
        }
         
        if resultStr == nil {
            return str
        }
        
        return resultStr!

    }
}


