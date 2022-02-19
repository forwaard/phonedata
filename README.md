# Phonedata

## 手机号码归属地信息库、手机号归属地查询

参考 https://github.com/xluohome/phonedata 基于 ruby 实现

- 归属地信息库文件大小：4,098,913 字节
- 归属地信息库最后更新：2021 年 08 月
- 手机号段记录条数：454336

### phone.dat 文件格式

        | 4 bytes |                     <- phone.dat 版本号（如：1701即17年1月份）
        ------------
        | 4 bytes |                     <-  第一个索引的偏移
        -----------------------
        |  offset - 8            |      <-  记录区
        -----------------------
        |  index                 |      <-  索引区
        -----------------------

1. 头部为 8 个字节，版本号为 4 个字节，第一个索引的偏移为 4 个字节；
2. 记录区 中每条记录的格式为"<省份>|<城市>|<邮编>|<长途区号>\0"。 每条记录以'\0'结束；
3. 索引区 中每条记录的格式为"<手机号前七位><记录区的偏移><卡类型>"，每个索引的长度为 9 个字节；

## 版本说明

项目采用 x.y.z.aaaa 的命名方式，在语义化版本的基础上加入了数据源更新版本

比如 0.3.0.2108 则代表是这个版本使用了 21 年 8 月的数据源，数据源的更新会导致语义化版本的升级，但是程序本身的升级（bugfix，new feature）不会导致数据源版本升级

比如 0.3.1.2108 代表 fix 了一个 bug，但数据源没变

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'phonedata'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install phonedata

## Usage

程序调用

```
require 'phonedata'

Phonedata.find("18755339810")

# #<struct Phonedata::Result
#  phone="18755339810",
#  province="安徽",
#  city="芜湖",
#  zipcode="241000",
#  areazone="0553",
#  card_type="中国移动">
```

方法清单

```
irb(main):002:0> Phonedata.methods(false)
=> [:find, :total_record, :first_record_offset, :find_from_cli, :file_version]
```

命令行调用

```
ph2loc 18755339810
```

返回

```
18755339810 安徽 芜湖 241000 241000 0553 中国移动
```

同时可以使用 Phonedata::Pd 这个单例类，将文件加载和查询放在了不同的环节，如果是服务端程序调用可以提前实例化一下，将文件加载到内存

```
irb(main):004:0> Phonedata::Pd.instance_methods(false)
=> [:find, :file_version, :total_record, :first_record_offset]

```

## Development

源码文件就一个，实现很简单

使用 rspec 跑单元测试

```
bundle exec rspec spec
```

## 感谢

感谢 https://github.com/xluohome 提供了原始库和数据文件
