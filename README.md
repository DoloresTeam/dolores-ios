**注意：由于被人恶意盗刷七牛云存储流量，所以我们决定暂时停用七牛。因此客户端的头像服务会受到影响。**

# Dolores iOS客户端

[注册账号](https://github.com/DoloresTeam/dolores-ios/issues/4)

## IM消息服务

实时消息这一块有很多开源的解决方案比如[XMPP](https://xmpp.org)，但是企业通信对IM这块的可靠性要求很高，所以目前我们打算使用比较成熟的云服务，后期如果时间比较充裕，考虑开发自己的IM服务器。在对比了市场上数十家IM云服务厂商以后，我们决定选择[环信](http://www.easemob.com)来为Dolores提供消息服务。

## 项目架构

### 第三方库引用

- 环信sdk以及相关UI组件，快速搭建IM聊天
- [Masonry](https://github.com/SnapKit/Masonry)用于UI自动布局编写。
- [ReactiveObjC](https://github.com/ReactiveCocoa/ReactiveCocoa)
- [Realm](https://github.com/realm/realm-cocoa)强大的移动端数据库，读写效率高，易于维护。
- AFNetworking，不用介绍了。
- [RATreeView](https://github.com/Augustyniak/RATreeView)较快捷的展示树状结构tableview，用于该项目中通讯录的UI编写。
- Qiniu：图片上传库。

### 数据库设计

Realm数据库对于一对多，多对多的支持非常好。人员组织架构的数据库设计如下：

- Staff（员工）可以对应多个Department（部门），一对多关系。通过Realm数据库反转，我们可以拿到该staff隶属于的所有部门。
- Department包含子部门和员工。同时Department有“parentId”字段，指向其父部门。如果parentId为空，则为根节点部门。

数据库文件见项目“RMDepartment”，“RMStaff”类。

#### 组织架构通讯录同步&更新

用户登录APP后，会从server拉取企业组织架构信息写入数据库。当从管理后台对组织架构进行修改，会通过环信sdk发送消息给APP，然后APP会根据当前数据库version从服务端获取更新数据，进行本地数据同步。

## 如何使用Dolores

- 参见[Dolores主要说明](https://github.com/DoloresTeam/Dolores)来部署服务端。

- 打开iOS端Dolores.xcworkspace，修改“DefineMacro.h”定义文件中的

  ```
  #define kBaseDoloresUrl                         @"http://www.dolores.store:3280"
  ```

为你的服务url。

- 修改AppDelegate中环信sdk key为您申请的key。

  ```
  - (void)registerEMSDK {
      EMOptions *options = [EMOptions optionsWithAppkey:@"1123170417178103#dolores"];
      options.enableConsoleLog = NO;
      options.isDeleteMessagesWhenExitGroup = NO;
      options.isDeleteMessagesWhenExitChatRoom = NO;
      options.enableDeliveryAck = YES;
      options.logLevel = EMLogLevelError;
      options.isAutoLogin = YES;
      [[EMClient sharedClient] initializeSDKWithOptions:options];
  }
  ```

- 执行“pod install”安装项目依赖的第三方库。

- run & chat.
