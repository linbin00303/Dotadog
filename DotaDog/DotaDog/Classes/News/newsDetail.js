window.onload = function(){
    // 拿到所有的图像标签
    var allImg = document.getElementsByTagName('img');
    // 遍历
    for(var i=0; i<allImg.length; i++){
       // 拿到单个图像标签
        var img = allImg[i];
        img.id = i;
        img.style.width = "100%"
       // 监听点击
        img.onclick = function(){

//            window.location.href = 'http://www.baidu.com';
            
            // 发送特殊的请求
            window.location.href = 'DDog://modalView'
            
        }
    }
    
    
    // 往页尾插入图片
    var img = document.createElement('img');
    img.src = "";
    img.style.width = "50px";
    document.body.appendChild(img);
    
}

