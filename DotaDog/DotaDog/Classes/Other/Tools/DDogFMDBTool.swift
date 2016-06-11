//
//  DDogFMDBTool.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/26.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import FMDB

class DDogFMDBTool: NSObject {
    
    // 创建单例
    static let shareInstance = DDogFMDBTool()
    
    // 队列
    lazy var queue: FMDatabaseQueue = {
        
         // 在沙盒中创建数据库路径
         let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
         let fullPath = basePath! + "/dotadog.sqlite"
//         print(fullPath)
        
        // 创建一个线程,用于线程保护
        let queue = FMDatabaseQueue(path: fullPath)
        return queue
        
    }()
    
    /*
    lazy var db: FMDatabase = {
        
        // 在沙盒中创建数据库路径
        let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        let fullPath = basePath! + "/dotadog.sqlite"
        
        let db = FMDatabase(path: fullPath)

        return db
    }() */
    
    override init() {
        super.init()
        
    }
    
    // MARK:- 创建一个表--DDL
    func update_createHeroesTable() -> () {
        // BLOB是二进制,存储NSData数据类型用的
        let sql = "CREATE TABLE IF NOT EXISTS hero(id INTEGER PRIMARY KEY NOT NULL, localized_name TEXT NOT NULL, name_en TEXT NOT NULL, name_zh TEXT NOT NULL, atk TEXT, bio TEXT,roles blob, hphover_image blob, sb_image blob, vert_image blob, icon blob)"
        queue.inDatabase { (db: FMDatabase!) in
            if db.executeUpdate(sql, withArgumentsInArray: nil) {
//                print("创建表成功")
            }else {
//                print("创建表失败")
            }
        }
    }
    
    // MARK:- 创建一个表--DDL
    func update_createItemsTable() -> () {
        // BLOB是二进制,存储NSData数据类型用的
        let sql = "CREATE TABLE IF NOT EXISTS items(id INTEGER PRIMARY KEY NOT NULL, name TEXT NOT NULL, dname TEXT NOT NULL, img TEXT NOT NULL, cost INTEGER NOT NULL, desc TEXT,notes TEXT, lore TEXT, created BOOL, lg_image blob)"
        queue.inDatabase { (db: FMDatabase!) in
            if db.executeUpdate(sql, withArgumentsInArray: nil) {
//                print("创建表成功")
            }else {
//                print("创建表失败")
            }
        }
    }
    
    // MARK:- 创建一个表--DDL
    func update_createAbilitysTable() -> () {
        // BLOB是二进制,存储NSData数据类型用的
        let sql = "CREATE TABLE IF NOT EXISTS ability(id INTEGER PRIMARY KEY AUTOINCREMENT, ability TEXT, affects TEXT, attrib TEXT, cmb TEXT, desc TEXT NOT NULL, dname TEXT NOT NULL, hurl TEXT NOT NULL, lore TEXT, notes TEXT ,hp2_image)"
        queue.inDatabase { (db: FMDatabase!) in
            if db.executeUpdate(sql, withArgumentsInArray: nil) {
//                print("创建表成功")
            }else {
//                print("创建表失败")
            }
        }
    }
    
    
    
    // MARK:- 删除一个表--DDL
    func update_dropTable(table : String) -> () {
        
        let sql = "drop table if exists \(table)"
        
        queue.inDatabase { (db: FMDatabase!) in
            
            if db.executeUpdate(sql, withArgumentsInArray: nil) {
//                print("删除表成功")
            }else {
//                print("删除表失败")
            }
            
        }
    }
    
    // MARK:- 增加一个英雄数据--DML
    func update_insertHeroData(sql : String ,objs : [AnyObject]) -> () {
        queue.inDatabase { (db: FMDatabase!) in

            if db.executeUpdate(sql, withArgumentsInArray: objs) {
            //    print("增加行成功")
            }else {
            //    print("增加行失败")
            }
        }
    }
    
    // MARK:- 增加一个物品数据--DML
    func update_insertItemsData(sql : String ,objs : [AnyObject]) -> () {
        queue.inDatabase { (db: FMDatabase!) in
            
            if db.executeUpdate(sql, withArgumentsInArray: objs) {
            //    print("增加行成功")
            }else {
            //    print("增加行失败")
            }
        }
    }
    
    // MARK:- 增加一个技能数据--DML
    func update_insertAbilitysData(sql : String ,objs : [AnyObject]) -> () {
        queue.inDatabase { (db: FMDatabase!) in
            
            if db.executeUpdate(sql, withArgumentsInArray: objs) {
            //    print("增加行成功")
            }else {
            //   print("增加行失败")
            }
        }
    }
    
    // MARK:- 删除一个数据--DML
    func update_deleteData(table : String) -> () {
        let sql = "delete from \(table)"
        queue.inDatabase { (db: FMDatabase!) in
            if db.executeUpdate(sql, withArgumentsInArray: nil) {
            //    print("删除行成功")
            }else {
            //    print("删除行失败")
            }
        }
        
    }
    
    // MARK:- 修改一个数据--DML
    func update_updateData() -> () {
        let sql = "update hero set age = 999 where name = 'zhangsan'"
        queue.inDatabase { (db: FMDatabase!) in
            if db.executeUpdate(sql, withArgumentsInArray: nil) {
//                print("修改数据成功")
            }else {
//                print("修改数据失败")
            }
        }
        
    }
    
}

// MARK:- 查询
extension DDogFMDBTool {
    
    // 返回某个表的行数
    func columnsFromTable(table : String , column : (result : Int32) -> ()) -> (){
        let sql = "select count(1) from \(table)"
        queue.inDatabase { (db: FMDatabase!) in
            let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
            var count : Int32 = 0
            while resultSet.next() {
                count = resultSet.intForColumnIndex(0)
            }
            column(result: count)
        }
    }
    
    // MARK:- 通过名称查询唯一值
    func query_DataByColumn(sql : String, targetString : String , finished : (results : AnyObject?) -> ()) -> () {
        var result : AnyObject?
        queue.inDatabase { (db: FMDatabase!) in
            let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
            while resultSet.next() {
                result = resultSet.stringForColumn(targetString)
            }
        }
        // 以闭包返回
        finished(results: result)
    }
    
    // MARK:- 通过名称查询多个值
    func query_DatasByColumn(sql : String, targetString : String , finished : (results : [String]?) -> ()) -> () {
        var result : AnyObject?
        var array = [String]()
        queue.inDatabase { (db: FMDatabase!) in
            let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
            while resultSet.next() {
                result = resultSet.stringForColumn(targetString)
                if result == nil { result = "" }
                array.append(result! as! String)
            }
        }
        // 可包装成一个数据模型,以闭包返回
        finished(results: array)
    }
    
    // MARK:- 通过英雄查询技能,返回字典数组,一个字典一个技能
    func query_abilityByColumn(sql : String, finished : (results : [[String : String]]?) -> ()) -> () {
        var result = [String : String]()
        var array = [[String : String]]()
        queue.inDatabase { (db: FMDatabase!) in
            let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
            while resultSet.next() {
                let ability = resultSet.stringForColumn("ability")
                result.updateValue(ability, forKey: "ability")
                let dname = resultSet.stringForColumn("dname")
                result.updateValue(dname, forKey: "dname")
                let desc = resultSet.stringForColumn("desc")
                result.updateValue(desc, forKey: "desc")
                let lore = resultSet.stringForColumn("lore")
                result.updateValue(lore, forKey: "lore")
                let notes = resultSet.stringForColumn("notes")
                result.updateValue(notes, forKey: "notes")
                
                array.append(result)
            }
        }
        // 可包装成一个数据模型,以闭包返回
        finished(results: array)
    }
    
//
//    // MARK:- 通过索引查询
//    func query_DataByColumnIndex() -> () {
//        let sql = "select count(1) from hero"
//        queue.inDatabase { (db: FMDatabase!) in
//            let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
//            while resultSet.next() {
//                let count = resultSet.intForColumnIndex(0)
//                
//                print(count)
//            }
//        }
//        
//        // 可包装成一个数据模型,以闭包返回?
//    }
    
   
}



extension DDogFMDBTool {
    // MARK:- 事务的实现(失败则回滚)
    func transactionUpdate() -> () {
        queue.inTransaction { (db: FMDatabase!, rollback) in
            
            let sql = "update t_stu set score = score + 10 where name = 'zhangsan'"
            let sql2 = "update t_stu set score2 = score - 10 where name = 'lisi'"
            let result1 = db.executeUpdate(sql, withArgumentsInArray: nil)
            let result2 = db.executeUpdate(sql2, withArgumentsInArray: nil)
            
            if result1 && result2 {
                
            }else {
                
                // 回滚 *rollback = rollback.memory
                rollback.memory = true
                
            }
        }
    }
    
    // MARK:- 执行多条语句
    func stamentsTest() -> () {
        let sql = "insert into t_stu(name, age, score) values ('zhangsan3', 18, 99);insert into t_stu(name, age, score) values ('zhangsan2', 18, 99);"
        queue.inDatabase { (db) in
            db.executeStatements(sql)
        }
    }
    
}
