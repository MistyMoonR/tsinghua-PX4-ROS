
## rosbag的用法
https://www.jianshu.com/p/6dd2c08d688e      



| 命令       | 作用                                                  |
| :--------- | :---------------------------------------------------- |
| check      | 确定一个包是否可以在当前系统中进行,或者是否可以迁移。 |
| decompress | 压缩一个或多个包文件。                                |
| filter     | 解压一个或多个包文件。                                |
| fix        | 在包文件中修复消息,以便在当前系统中播放。             |
| help       | 获取相关命令指示帮助信息                              |
| info       | 总结一个或多个包文件的内容。                          |
| play       | 以一种时间同步的方式回放一个或多个包文件的内容。      |
| record     | 用指定主题的内容记录一个包文件。                      |
| reindex    | 重新索引一个或多个包文件。                            |


| 命令            | 作用                 |
| :-------------- | :------------------- |
| -r              | 速率                 |
| -l              | 循环loop             |
| --topic /topic1 | 只播放选择topic      |
| --pause         | 开始暂停,空格恢复    |
| -a              | record 记录所有topic |
